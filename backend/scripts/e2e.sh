#!/usr/bin/env bash
# End-to-end test of the whole API (auth, RBAC, catalogue, inventory, sales
# orders, analytics, forecasting, i18n) against a running API.
#
# Usage (API running, migrations applied, accounts seeded):
#   go run ./cmd/seed --auth-only     # once: roles + the Super Admin account
#   bash scripts/e2e.sh
#   API_URL=http://localhost:9000/api/v1 LOW_STOCK_DEFAULT_THRESHOLD=5 bash scripts/e2e.sh
#   ADMIN_EMAIL=me@example.com ADMIN_PASSWORD=... bash scripts/e2e.sh
#
# The script logs in as the Super Admin first and sends that access token on
# every request; the auth section then checks 401/403 with other tokens.
# ADMIN_EMAIL / ADMIN_PASSWORD default to the seeder's defaults.
# LOW_STOCK_DEFAULT_THRESHOLD must match the API's value (default 10).
# Every run uses unique names/SKUs/emails, so it can be re-run against the same
# DB. Created products/categories/customers are soft-deleted at the end. Their
# stock_movements and inventories rows stay, because movements are immutable.
# The run's users and roles are removed for good at the end (go run
# ./cmd/seed --clean-e2e-run=$RUN, needs Go and backend/.env pointing at the
# API's database); set E2E_SKIP_CLEANUP=1 to keep them.
# Exits 1 if any check fails.
B=${API_URL:-http://localhost:8080/api/v1}
THRESHOLD=${LOW_STOCK_DEFAULT_THRESHOLD:-10}
ADMIN_EMAIL=${ADMIN_EMAIL:-admin@example.com}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-admin12345}
RUN=$(date +%s)
CODES=$(mktemp); trap 'rm -f "$CODES"' EXIT
pass=0; fail=0
TOKEN=

# req METHOD PATH [BODY] -> sets $code and $body
# LANG_HEADER (optional) is sent as Accept-Language, e.g. LANG_HEADER=en req ...
# TOKEN (when set) is sent as "Authorization: Bearer $TOKEN".
req() {
  local out lang=() authz=()
  [ -n "$LANG_HEADER" ] && lang=(-H "Accept-Language: $LANG_HEADER")
  [ -n "$TOKEN" ] && authz=(-H "Authorization: Bearer $TOKEN")
  if [ -n "$3" ]; then
    out=$(curl -s -w $'\n%{http_code}' -X "$1" "$B$2" "${lang[@]}" "${authz[@]}" -H 'Content-Type: application/json' -d "$3")
  else
    out=$(curl -s -w $'\n%{http_code}' -X "$1" "$B$2" "${lang[@]}" "${authz[@]}")
  fi
  code=${out##*$'\n'}; body=${out%$'\n'*}
}
# as TOKEN METHOD PATH [BODY] -> req with another caller ("" = no token)
as() { local TOKEN=$1; shift; req "$@"; }
# jstr KEY [JSON] -> the first string value of KEY
jstr() { grep -o "\"$1\":\"[^\"]*\"" <<<"${2:-$body}" | head -1 | cut -d'"' -f4; }
check() { # label expected-code [grep-pattern]
  if [ "$code" = "$2" ] && { [ -z "$3" ] || grep -q -- "$3" <<<"$body"; }; then
    pass=$((pass+1)); echo "PASS  $1 -> $code"
  else
    fail=$((fail+1)); echo "FAIL  $1 -> $code (want $2 ${3:+/ $3})"; echo "      $body"
  fi
}
jid() { grep -o '"id":[0-9]*' <<<"$body" | head -1 | cut -d: -f2; }
# jnum KEY -> the first integer value of KEY in $body
jnum() { grep -o "\"$1\":[0-9]*" <<<"$body" | head -1 | cut -d: -f2; }
# no_count LABEL -> passes when $body (a user answer) has no user_count:
# that field belongs to the role endpoints, never to a role inside a user.
no_count() {
  if [ "${code:0:1}" = 2 ] && ! grep -q '"user_count"' <<<"$body"; then
    pass=$((pass+1)); echo "PASS  $1: no user_count in the embedded role"
  else
    fail=$((fail+1)); echo "FAIL  $1 -> $code: $body"
  fi
}
# login EMAIL PASSWORD -> sets $ACCESS and $REFRESH (empty on failure)
login() {
  as "" POST /auth/login "{\"email\":\"$1\",\"password\":\"$2\"}"
  ACCESS=$(jstr access_token); REFRESH=$(jstr refresh_token)
}

echo "== Auth: log in as the Super Admin (every request below carries this token)"
login "$ADMIN_EMAIL" "$ADMIN_PASSWORD"
if [ "$code" != 200 ] || [ -z "$ACCESS" ]; then
  echo "FATAL: can't log in as $ADMIN_EMAIL -> $code $body"
  echo "       seed the accounts (go run ./cmd/seed --auth-only) or set ADMIN_EMAIL / ADMIN_PASSWORD"
  exit 1
fi
pass=$((pass+1)); echo "PASS  login as Super Admin -> 200"
TOKEN=$ACCESS
grep -q '"token_type":"Bearer","expires_in":900' <<<"$body" && { pass=$((pass+1)); echo "PASS  Bearer token, 15 minutes"; } || { fail=$((fail+1)); echo "FAIL  token shape: $body"; }
req GET /auth/me;                                         check "me: Super Admin sees every permission" 200 '"is_system":true'
ADMIN_ID=$(jid)
expect() { # label actual expected
  [ "$2" = "$3" ] && { pass=$((pass+1)); echo "PASS  $1 ($2)"; } || { fail=$((fail+1)); echo "FAIL  $1: got '$2', want '$3'"; }
}
expect "me lists the whole catalog" "$(grep -o '"[a-z_]*\.[a-z_]*"' <<<"$body" | wc -l | tr -d ' ')" 32
req GET /permissions;                                     check "permission catalog" 200 '"key":"roles.assign_permissions"'
expect "32 permissions in the catalog" "$(grep -o '"key":' <<<"$body" | wc -l | tr -d ' ')" 32

echo "== Auth: 401 without a valid token"
as ""      GET /products;                                 check "no token" 401 '"code":"unauthorized"'
as "abc"   GET /products;                                 check "garbage token" 401 '"code":"unauthorized"'
curl -s -o /dev/null -w '%{http_code}' "${B%/api/v1}/health" | grep -q 200 && { pass=$((pass+1)); echo "PASS  /health stays public"; } || { fail=$((fail+1)); echo "FAIL  /health"; }
LANG_HEADER=en as "" GET /products;                       check "401 message in English" 401 'authentication required'
unset LANG_HEADER
as "" POST /auth/login "{\"email\":\"$ADMIN_EMAIL\",\"password\":\"wrong-password\"}"; check "login: wrong password" 401 '"code":"invalid_credentials"'
as "" POST /auth/login '{"email":"nobody@example.test","password":"whatever1"}';   check "login: unknown email, same answer" 401 'email atau password salah'
as "" POST /auth/login '{"email":"","password":""}';                                check "login: missing fields" 422 '"field":"password"'

echo "== Auth: refresh rotation and logout (a second admin session)"
login "$ADMIN_EMAIL" "$ADMIN_PASSWORD"; A1=$ACCESS; R1=$REFRESH
as "" POST /auth/refresh "{\"refresh_token\":\"$R1\"}";   check "refresh -> new pair" 200 '"access_token"'
A2=$(jstr access_token); R2=$(jstr refresh_token)
[ -n "$R2" ] && [ "$R2" != "$R1" ] && [ "$A2" != "$A1" ] && { pass=$((pass+1)); echo "PASS  both tokens rotated"; } || { fail=$((fail+1)); echo "FAIL  tokens not rotated"; }
as "" POST /auth/refresh "{\"refresh_token\":\"$R1\"}";   check "old refresh token is single-use" 401 '"code":"unauthorized"'
as "$A2" GET /auth/me;                                    check "new access token works" 200 "\"id\":$ADMIN_ID"
as "" POST /auth/refresh "{\"refresh_token\":\"$A2\"}";   check "an access token is not a refresh token" 401
as "$R2" GET /auth/me;                                    check "a refresh token is not an access token" 401
as "" POST /auth/logout "{\"refresh_token\":\"$R2\"}";    check "logout" 204
as "" POST /auth/refresh "{\"refresh_token\":\"$R2\"}";   check "refresh after logout" 401 'dicabut'
as "" POST /auth/logout "{\"refresh_token\":\"$R2\"}";    check "logout twice is fine" 204
as "" POST /auth/logout '{"refresh_token":"forged"}';     check "logout with a forged token" 401

echo "== Concurrency: one refresh token used 5x in parallel -> exactly one wins (row lock)"
login "$ADMIN_EMAIL" "$ADMIN_PASSWORD"; RACE_REFRESH=$REFRESH
for i in 1 2 3 4 5; do
  curl -s -o /dev/null -w '%{http_code}\n' -X POST "$B/auth/refresh" -H 'Content-Type: application/json' -d "{\"refresh_token\":\"$RACE_REFRESH\"}" &
done > "$CODES"; wait
expect "exactly one refresh succeeds" "$(grep -c '^200$' "$CODES")" 1
expect "the other four are refused"  "$(grep -c '^401$' "$CODES")" 4

echo "== RBAC: Staff role (seeded) -> 403 on what it lacks"
req GET "/roles?search=Staff";                            check "find the Staff role" 200 '"name":"Staff"'
STAFF_ROLE=$(grep -o '"id":[0-9]*,"name":"Staff"' <<<"$body" | head -1 | grep -o '[0-9]*')
req GET "/roles?search=Super%20Admin";                    check "find the Super Admin role" 200 '"is_system":true'
ADMIN_ROLE=$(jid)
STAFF_EMAIL="e2e.staff.$RUN@example.test"
req POST /users "{\"email\":\" E2E.Staff.$RUN@Example.TEST \",\"password\":\"rahasia123\",\"name\":\"E2E Staff $RUN\",\"role_id\":$STAFF_ROLE}"
check "create a Staff user (email lowercased, no hash in response)" 201 "\"email\":\"$STAFF_EMAIL\""
STAFF_USER=$(jid)
grep -q 'password' <<<"$body" && { fail=$((fail+1)); echo "FAIL  password leaked: $body"; } || { pass=$((pass+1)); echo "PASS  no password or hash in the response"; }
req POST /users "{\"email\":\"$STAFF_EMAIL\",\"password\":\"rahasia123\",\"name\":\"X\",\"role_id\":$STAFF_ROLE}"; check "duplicate email" 409 'email sudah dipakai pengguna lain'
req POST /users '{"email":"nope","password":"short","name":"","role_id":999999}';  check "invalid user fields" 422 '"field":"role_id"'
login "$STAFF_EMAIL" rahasia123; STAFF=$ACCESS
[ -n "$STAFF" ] && { pass=$((pass+1)); echo "PASS  Staff can log in"; } || { fail=$((fail+1)); echo "FAIL  staff login: $body"; }
as "$STAFF" GET /auth/me;                                 check "me: Staff has sales_orders.confirm" 200 '"sales_orders.confirm"'
grep -q '"products.delete"' <<<"$body" && { fail=$((fail+1)); echo "FAIL  staff has products.delete"; } || { pass=$((pass+1)); echo "PASS  me: Staff lacks products.delete"; }
as "$STAFF" GET /products;                                check "Staff: view products" 200
as "$STAFF" GET /analytics/summary;                       check "Staff: view analytics" 200
as "$STAFF" POST /products '{"sku":"E2E-X","name":"X","price":1}'; check "Staff: create product" 403 '"code":"forbidden"'
as "$STAFF" DELETE /products/999999;                      check "Staff: delete product (before 404)" 403 'products.delete'
as "$STAFF" DELETE /categories/999999;                    check "Staff: delete category" 403 'categories.delete'
as "$STAFF" GET /users;                                   check "Staff: list users" 403 'users.view'
as "$STAFF" POST /roles '{"name":"E2E Hack"}';            check "Staff: create role" 403
as "$STAFF" PUT /roles/$STAFF_ROLE/permissions '{"permission_keys":["users.view"]}'; check "Staff: edit own role" 403
as "$STAFF" POST /sales-orders '{"items":[]}';            check "Staff: may create orders (reaches validation)" 422 '"field":"items"'
as "$STAFF" PATCH /sales-orders/999999/status '{"status":"CONFIRMED"}'; check "Staff: may confirm (reaches the order lookup)" 404
LANG_HEADER=en as "$STAFF" POST /products '{}';           check "403 message in English" 403 'you do not have the products.create permission'
unset LANG_HEADER

echo "== Reuse detection: a revoked refresh token used again ends EVERY session of that user"
# A refresh token works once. If a rotated-away (revoked) one comes back, two
# parties hold it and the server can't tell which is asking, so it revokes all
# of the user's refresh tokens — while answering like any other failed refresh.
REUSE_EMAIL="e2e.reuse.$RUN@example.test"
req POST /users "{\"email\":\"$REUSE_EMAIL\",\"password\":\"rahasia123\",\"name\":\"E2E Reuse $RUN\",\"role_id\":$STAFF_ROLE}"
check "create a user for the reuse scenario" 201; REUSE_USER=$(jid)
login "$REUSE_EMAIL" rahasia123; PHONE_ACCESS=$ACCESS; PHONE=$REFRESH   # session 1
login "$REUSE_EMAIL" rahasia123; LAPTOP=$REFRESH                        # session 2, same user
as "" POST /auth/refresh "{\"refresh_token\":\"$PHONE\"}"
check "(a) first use of the phone's refresh token: ordinary rotation" 200 '"refresh_token"'
PHONE_NEXT=$(jstr refresh_token)
as "" POST /auth/refresh "{\"refresh_token\":\"$PHONE_NEXT\"}"
check "(a) the rotated token works too (normal use never trips detection)" 200 '"refresh_token"'
PHONE_NEXT=$(jstr refresh_token)
# What an ordinary failed refresh looks like, to compare against.
as "" POST /auth/refresh "{\"refresh_token\":\"$PHONE_ACCESS\"}"; PLAIN_FAILURE="$code $body"
as "" POST /auth/refresh "{\"refresh_token\":\"$PHONE\"}"
check "(b) the SAME phone token again (reuse)" 401 '"code":"unauthorized"'
expect "the reuse answer is byte-for-byte an ordinary failed refresh (nothing reveals the detection)" "$code $body" "$PLAIN_FAILURE"
as "" POST /auth/refresh "{\"refresh_token\":\"$LAPTOP\"}"
check "(b) the LAPTOP session of the same user was revoked too" 401
as "" POST /auth/refresh "{\"refresh_token\":\"$PHONE_NEXT\"}"
check "(b) the phone's latest (rotated) token was revoked too" 401
login "$REUSE_EMAIL" rahasia123
check "the real user can still log in with the password" 200
as "" POST /auth/refresh "{\"refresh_token\":\"$REFRESH\"}"
check "and the new session refreshes normally" 200
req DELETE /users/$REUSE_USER;                            check "remove the reuse user" 204

echo "== RBAC: custom role, permissions replaced live (no cache)"
req POST /roles "{\"name\":\"E2E Gudang $RUN\",\"description\":\"stok saja\"}"; check "create role" 201 '"permissions":\[\]'
ROLE=$(jid)
req POST /roles "{\"name\":\"E2E Gudang $RUN\"}";         check "duplicate role name" 409
req PUT /roles/$ROLE/permissions '{"permission_keys":["inventory.view","nope.nope"]}'; check "unknown permission key" 422 '"field":"permission_keys\[1\]"'
req PUT /roles/$ROLE/permissions '{"permission_keys":["inventory.view","inventory.record_movement","inventory.view"]}'
check "set permissions (deduplicated)" 200 '"permissions":\["inventory.view","inventory.record_movement"\]'
GUDANG_EMAIL="e2e.gudang.$RUN@example.test"
req POST /users "{\"email\":\"$GUDANG_EMAIL\",\"password\":\"rahasia123\",\"name\":\"E2E Gudang $RUN\",\"role_id\":$ROLE}"; GUDANG=$(jid)
login "$GUDANG_EMAIL" rahasia123; G=$ACCESS; GR=$REFRESH
as "$G" GET /inventory/low-stock;                         check "custom role: inventory allowed" 200
as "$G" GET /products;                                    check "custom role: products denied" 403
req PUT /roles/$ROLE/permissions '{"permission_keys":["products.view"]}'; check "replace (not append) the list" 200 '"permissions":\["products.view"\]'
as "$G" GET /products;                                    check "same token, new permission applies at once" 200
as "$G" GET /inventory/low-stock;                         check "same token, removed permission denied at once" 403
req DELETE /roles/$ROLE;                                  check "delete a role in use" 409 'masih terhubung dengan 1 pengguna'
req GET /roles/$ROLE;                                     check "user_count matches the 409 (1)" 200 '"user_count":1'

echo "== RBAC: the Super Admin role is locked"
req DELETE /roles/$ADMIN_ROLE;                            check "delete system role" 409 'role sistem'
req PATCH /roles/$ADMIN_ROLE '{"name":"Boss"}';           check "rename system role" 409
req PUT /roles/$ADMIN_ROLE/permissions '{"permission_keys":[]}'; check "set permissions of system role" 409
req POST /roles "{\"name\":\"E2E Empty $RUN\"}"; EMPTY=$(jid)
req DELETE /roles/$EMPTY;                                 check "delete an unused role" 204

echo "== Users: self-protection, deactivation, deletion"
req PATCH /users/$ADMIN_ID '{"is_active":false}';         check "can't deactivate yourself" 409 'akun sendiri'
req PATCH /users/$ADMIN_ID "{\"role_id\":$STAFF_ROLE}";   check "can't change your own role" 409
req DELETE /users/$ADMIN_ID;                              check "can't delete yourself" 409
req GET /users/$ADMIN_ID;                                 check "self-protection: account unchanged (active, still Super Admin)" 200 "\"role_id\":$ADMIN_ROLE,\"role\":{\"id\":$ADMIN_ROLE,\"name\":\"Super Admin\""
grep -q '"is_active":true' <<<"$body" && { pass=$((pass+1)); echo "PASS  self-protection: still active"; } || { fail=$((fail+1)); echo "FAIL  admin changed: $body"; }
grep -q '"user_count"' <<<"$body" && { fail=$((fail+1)); echo "FAIL  a role inside a user claims a user_count: $body"; } || { pass=$((pass+1)); echo "PASS  a role inside a user has no (false) user_count"; }
req PATCH /users/$GUDANG '{"is_active":false}';           check "deactivate a user" 200 '"is_active":false'
as "$G" GET /products;                                    check "their live access token stops at once" 401 'tidak aktif'
as "" POST /auth/refresh "{\"refresh_token\":\"$GR\"}";   check "their refresh token was revoked" 401
login "$GUDANG_EMAIL" rahasia123;                         check "an inactive user can't log in" 401 invalid_credentials
req DELETE /users/$GUDANG;                                check "delete a user" 204
req GET /users/$GUDANG;                                   check "deleted user is gone" 404
req GET "/users?search=e2e.staff.$RUN";                   check "list users with search" 200 '"total":1'
# The only user of ROLE is now soft-deleted; it still holds role_id as history.
req DELETE /roles/$ROLE;                                  check "role used only by a DELETED user still can't be deleted" 409 'termasuk yang sudah dihapus'
req GET /roles/$ROLE;                                     check "that role is still there" 200 "\"id\":$ROLE"
expect "user_count still counts the soft-deleted user (same number as the 409)" "$(jnum user_count)" 1

echo "== user_count: users per role, in GET /roles and GET /roles/:id"
# user_count = every user row that references the role, soft-deleted ones
# included: exactly the rows that make DELETE /roles/:id answer 409.
req POST /roles "{\"name\":\"E2E Count $RUN\"}";          check "create a role to count" 201 '"user_count":0'
COUNT_ROLE=$(jid)
req GET /roles/$COUNT_ROLE;                               check "detail: a new role has user_count 0" 200 '"user_count":0'
for n in 1 2 3; do
  req POST /users "{\"email\":\"e2e.count$n.$RUN@example.test\",\"password\":\"rahasia123\",\"name\":\"E2E Count $n $RUN\",\"role_id\":$COUNT_ROLE}"
  eval "COUNT_U$n=\$(jid)"
done
no_count "POST /users"
req GET "/users?search=e2e.count1.$RUN";                  no_count "GET /users"
req GET /users/$COUNT_U1;                                 no_count "GET /users/:id"
req GET "/roles?search=E2E%20Count%20$RUN";               check "list: the role with 3 users" 200 '"total":1'
expect "list: user_count 3" "$(jnum user_count)" 3
req GET /roles/$COUNT_ROLE;                               expect "detail: user_count 3 (same number as the list)" "$(jnum user_count)" 3
req PATCH /users/$COUNT_U1 '{"is_active":false}';         no_count "PATCH /users/:id keeping the role"
req GET /roles/$COUNT_ROLE;                               expect "an inactive user still counts" "$(jnum user_count)" 3
req DELETE /users/$COUNT_U2
req GET /roles/$COUNT_ROLE;                               expect "a soft-deleted user still counts" "$(jnum user_count)" 3
req DELETE /roles/$COUNT_ROLE;                            check "the 409 names the same count" 409 'masih terhubung dengan 3 pengguna'
req PATCH /users/$COUNT_U3 "{\"role_id\":$STAFF_ROLE}";   no_count "PATCH /users/:id changing the role"
login "e2e.count3.$RUN@example.test" rahasia123;          no_count "POST /auth/login"
as "$ACCESS" GET /auth/me;                                no_count "GET /auth/me"
req GET /roles/$COUNT_ROLE;                               expect "moving a user to another role lowers it" "$(jnum user_count)" 2
req GET "/roles?search=Super%20Admin";                    check "the Super Admin role has a count too" 200 '"user_count":[1-9]'
LANG_HEADER=en req DELETE /roles/$COUNT_ROLE;             check "409 in English says deleted users count" 409 'including deleted ones'
unset LANG_HEADER

echo "== Guardrail: only a Super Admin can hand out Super Admin power"
# A "user manager" holds every users.* permission plus everything Staff has
# (so it may manage Staff accounts), but is not a Super Admin.
req GET /roles/$STAFF_ROLE
STAFF_KEYS=$(grep -o '"permissions":\[[^]]*\]' <<<"$body" | sed 's/^"permissions":\[//; s/\]$//')
UM_KEYS="\"users.view\",\"users.create\",\"users.update\",\"users.delete\",$STAFF_KEYS"
req POST /roles "{\"name\":\"E2E UserMgr $RUN\"}"; UM_ROLE=$(jid)
req PUT /roles/$UM_ROLE/permissions "{\"permission_keys\":[$UM_KEYS]}"; check "user-manager role (users.* + Staff's permissions)" 200 '"users.delete"'
UM_EMAIL="e2e.usermgr.$RUN@example.test"
req POST /users "{\"email\":\"$UM_EMAIL\",\"password\":\"rahasia123\",\"name\":\"E2E UserMgr $RUN\",\"role_id\":$UM_ROLE}"; UM_USER=$(jid)
login "$UM_EMAIL" rahasia123; UM=$ACCESS
as "$UM" POST /users "{\"email\":\"e2e.um-staff.$RUN@example.test\",\"password\":\"rahasia123\",\"name\":\"E2E UM Staff $RUN\",\"role_id\":$STAFF_ROLE}"
check "user manager CAN create a Staff user (control)" 201
UM_STAFF=$(jid)
as "$UM" POST /users "{\"email\":\"e2e.um-boss.$RUN@example.test\",\"password\":\"rahasia123\",\"name\":\"E2E Boss $RUN\",\"role_id\":$ADMIN_ROLE}"
check "user manager can't CREATE a Super Admin" 403 'hanya Super Admin'
as "$UM" PATCH /users/$UM_STAFF "{\"role_id\":$ADMIN_ROLE}"; check "user manager can't PROMOTE someone to Super Admin" 403 'hanya Super Admin'
as "$UM" PATCH /users/$UM_USER "{\"role_id\":$ADMIN_ROLE}";  check "user manager can't promote THEMSELVES" 409 'role akun sendiri'
as "$UM" PATCH /users/$ADMIN_ID '{"password":"dibajak123"}'; check "user manager can't change a Super Admin's password" 403 'hanya Super Admin'
as "$UM" PATCH /users/$ADMIN_ID '{"is_active":false}';       check "user manager can't deactivate a Super Admin" 403
as "$UM" DELETE /users/$ADMIN_ID;                            check "user manager can't delete a Super Admin" 403
req GET /users/$UM_STAFF;                                    check "the Staff user is still Staff" 200 "\"role_id\":$STAFF_ROLE"
login "$ADMIN_EMAIL" "$ADMIN_PASSWORD";                      check "the Super Admin password is unchanged" 200
req GET "/users?search=e2e.um-boss.$RUN";                    check "no Super Admin was created" 200 '"total":0'

echo "== Roles list for a user manager (users.create/update, no roles.view)"
as "$UM" GET /roles;                                         check "user manager CAN list roles (for the role dropdown)" 200 '"user_count":'
grep -q '"name":"Staff"' <<<"$body" && { pass=$((pass+1)); echo "PASS  the list carries the roles"; } || { fail=$((fail+1)); echo "FAIL  role list: $body"; }
as "$UM" GET /roles/$STAFF_ROLE;                             check "but NOT the role detail" 403 'roles.view'
as "$UM" GET /permissions;                                   check "nor the permission catalog" 403 'roles.view'
as "$UM" POST /roles '{"name":"E2E Hack"}';                  check "nor create roles" 403 'roles.create'
req POST /roles "{\"name\":\"E2E UsersView $RUN\"}"; UV_ROLE=$(jid)
req PUT /roles/$UV_ROLE/permissions '{"permission_keys":["users.view"]}'
req POST /users "{\"email\":\"e2e.usersview.$RUN@example.test\",\"password\":\"rahasia123\",\"name\":\"E2E UsersView $RUN\",\"role_id\":$UV_ROLE}"; UV_USER=$(jid)
login "e2e.usersview.$RUN@example.test" rahasia123; UV=$ACCESS
as "$UV" GET /roles;                                         check "users.view alone can't list roles" 403 'roles.view / users.create / users.update'
as "$STAFF" GET /roles;                                      check "Staff can't list roles" 403
LANG_HEADER=en as "$UV" GET /roles;                          check "the any-of 403 in English" 403 'you do not have the roles.view / users.create / users.update permission'
unset LANG_HEADER

echo "== Guardrail: a non-Super-Admin can only give, change or delete what they hold"
# "Power" holds everything the user manager has plus two permissions it
# lacks. "Weak" holds users.* only, so even Staff is beyond it.
req POST /roles "{\"name\":\"E2E Power $RUN\"}"; POWER_ROLE=$(jid)
req PUT /roles/$POWER_ROLE/permissions "{\"permission_keys\":[$UM_KEYS,\"products.delete\",\"roles.assign_permissions\"]}"; check "a role stronger than the user manager" 200 '"products.delete"'
POWER_EMAIL="e2e.power.$RUN@example.test"
req POST /users "{\"email\":\"$POWER_EMAIL\",\"password\":\"rahasia123\",\"name\":\"E2E Power $RUN\",\"role_id\":$POWER_ROLE}"; check "the Super Admin creates a Power user" 201
POWER_USER=$(jid)
as "$UM" POST /users "{\"email\":\"e2e.um-power.$RUN@example.test\",\"password\":\"rahasia123\",\"name\":\"X\",\"role_id\":$POWER_ROLE}"
check "user manager can't CREATE a user with a stronger role" 403 "memberikan role ..E2E Power $RUN"
as "$UM" PATCH /users/$UM_STAFF "{\"role_id\":$POWER_ROLE}"; check "user manager can't GIVE a stronger role" 403 "memberikan role ..E2E Power $RUN"
as "$UM" PATCH /users/$UM_USER "{\"role_id\":$POWER_ROLE}";  check "nor to themselves (still the self rule: 409)" 409 'role akun sendiri'
as "$UM" PATCH /users/$POWER_USER '{"password":"dibajak123"}'; check "user manager can't RESET a stronger user's password" 403 "pengguna dengan role ..E2E Power $RUN"
login "$POWER_EMAIL" dibajak123;                             check "so nobody can log in as Power with a password they set" 401
login "$POWER_EMAIL" rahasia123;                             check "the Power password is unchanged" 200
as "$UM" PATCH /users/$POWER_USER '{"is_active":false}';     check "user manager can't DEACTIVATE a stronger user" 403 'pengguna dengan role'
as "$UM" PATCH /users/$POWER_USER "{\"role_id\":$STAFF_ROLE}"; check "nor demote them (it changes a stronger account)" 403 'pengguna dengan role'
as "$UM" DELETE /users/$POWER_USER;                          check "user manager can't DELETE a stronger user" 403 'pengguna dengan role'
req GET /users/$POWER_USER;                                  check "the Power user is untouched (still Power)" 200 "\"role_id\":$POWER_ROLE"
grep -q '"is_active":true' <<<"$body" && { pass=$((pass+1)); echo "PASS  Power user still active"; } || { fail=$((fail+1)); echo "FAIL  Power user changed: $body"; }
LANG_HEADER=en as "$UM" DELETE /users/$POWER_USER;           check "target-side 403 in English" 403 "you can't change or delete a user with the"
unset LANG_HEADER
as "$UM" PATCH /users/$UM_STAFF '{"name":"E2E UM Staff renamed"}'; check "control: a Staff user is within scope" 200 'renamed'
as "$UM" PATCH /users/$UM_USER '{"name":"E2E UserMgr self"}';    check "control: editing yourself is not limited by the scope" 200 'self'
req POST /roles "{\"name\":\"E2E Weak $RUN\"}"; WEAK_ROLE=$(jid)
req PUT /roles/$WEAK_ROLE/permissions '{"permission_keys":["users.view","users.create","users.update","users.delete"]}'
req POST /users "{\"email\":\"e2e.weak.$RUN@example.test\",\"password\":\"rahasia123\",\"name\":\"E2E Weak $RUN\",\"role_id\":$WEAK_ROLE}"; WEAK_USER=$(jid)
login "e2e.weak.$RUN@example.test" rahasia123; WEAK=$ACCESS
as "$WEAK" POST /users "{\"email\":\"e2e.weak-staff.$RUN@example.test\",\"password\":\"rahasia123\",\"name\":\"X\",\"role_id\":$STAFF_ROLE}"
check "users.* alone can't create even a Staff user" 403 'memberikan role ..Staff'
LANG_HEADER=en as "$WEAK" PATCH /users/$UM_STAFF '{"password":"dibajak123"}'; check "nor reset a Staff password (English)" 403 "you can't change or delete a user with the ..Staff.. role"
unset LANG_HEADER

echo "== Guardrail: a non-Super-Admin can only grant permissions they hold"
# A "role manager" may assign permissions but only holds a few itself.
req POST /roles "{\"name\":\"E2E RoleMgr $RUN\"}"; RM_ROLE=$(jid)
req PUT /roles/$RM_ROLE/permissions '{"permission_keys":["roles.view","roles.create","roles.assign_permissions","products.view"]}'; check "role-manager role" 200
RM_EMAIL="e2e.rolemgr.$RUN@example.test"
req POST /users "{\"email\":\"$RM_EMAIL\",\"password\":\"rahasia123\",\"name\":\"E2E RoleMgr $RUN\",\"role_id\":$RM_ROLE}"; RM_USER=$(jid)
login "$RM_EMAIL" rahasia123; RM=$ACCESS
as "$RM" POST /roles "{\"name\":\"E2E Viewer $RUN\"}";       check "role manager creates a role" 201
VIEWER=$(jid)
as "$RM" PUT /roles/$VIEWER/permissions '{"permission_keys":["products.view"]}'; check "grant a permission they hold (control)" 200 '"permissions":\["products.view"\]'
as "$RM" PUT /roles/$VIEWER/permissions '{"permission_keys":["products.view","users.delete"]}'; check "grant one they don't hold" 403 'izin \\"users.delete'
req GET /roles/$VIEWER;                                      check "the refused grant changed nothing" 200 '"permissions":\["products.view"\]'
as "$RM" PUT /roles/$RM_ROLE/permissions '{"permission_keys":["roles.view","roles.create","roles.assign_permissions","products.view","users.update"]}'
check "can't escalate their OWN role either" 403 'izin \\"users.update'
req GET /roles/$RM_ROLE
grep -q '"users.update"' <<<"$body" && { fail=$((fail+1)); echo "FAIL  role manager escalated: $body"; } || { pass=$((pass+1)); echo "PASS  own role still without users.update"; }
as "$RM" PUT /roles/$STAFF_ROLE/permissions '{"permission_keys":["users.view"]}'; check "can't grant it to another role (Staff)" 403
as "$RM" PUT /roles/$ADMIN_ROLE/permissions '{"permission_keys":[]}';            check "can't touch the system role" 409
for id in $UM_STAFF $UM_USER $RM_USER $UV_USER $POWER_USER $WEAK_USER $COUNT_U1 $COUNT_U3; do req DELETE /users/$id; done

echo "== Category"
req POST /categories "{\"name\":\"  E2E Minuman $RUN \",\"description\":\"kopi & teh\"}"; check "create category (trimmed)" 201 "\"name\":\"E2E Minuman $RUN\""
CAT=$(jid)
req POST /categories "{\"name\":\"E2E Minuman $RUN\"}";            check "duplicate name" 409 '"conflict"'
req POST /categories '{"name":"   "}';                              check "empty name" 422 '"field":"name"'
req POST /categories '{bad json';                                   check "bad json" 400 invalid_body
req GET  /categories/$CAT;                                          check "get by id" 200 "\"id\":$CAT"
req GET  /categories/999999;                                        check "get missing" 404 not_found
req GET  /categories/abc;                                           check "get bad id" 400 invalid_id
req GET  "/categories?search=e2e%20minuman%20$RUN";                 check "list search (case-insensitive)" 200 '"total":1'
req PATCH /categories/$CAT '{"description":"minuman dingin"}';      check "patch description" 200 "\"name\":\"E2E Minuman $RUN\",\"description\":\"minuman dingin\""
req POST /categories "{\"name\":\"E2E Makanan $RUN\"}";             check "create 2nd category" 201
CAT2=$(jid)
req PATCH /categories/$CAT2 "{\"name\":\"E2E Minuman $RUN\"}";      check "rename to taken name" 409

echo "== Product <-> Category"
req POST /products "{\"sku\":\"E2E-A-$RUN\",\"name\":\"E2E Kopi\",\"price\":45000,\"category_id\":$CAT}"; check "create product with category" 201 "\"category\":{\"id\":$CAT"
PA=$(jid)
req POST /products "{\"sku\":\"E2E-B-$RUN\",\"name\":\"E2E Roti\",\"price\":15000}";                        check "create product without category" 201 '"category_id":null'
PB=$(jid)
req POST /products "{\"sku\":\"E2E-C-$RUN\",\"name\":\"X\",\"category_id\":999999}";                         check "unknown category_id" 422 '"field":"category_id"'
req GET  /products/$PA;                                             check "get product preloads category" 200 "\"name\":\"E2E Minuman $RUN\""
req DELETE /categories/$CAT;                                        check "delete category in use" 409 "masih dipakai oleh 1 produk"
req PATCH /products/$PB "{\"category_id\":$CAT2}";                  check "patch: move product B to cat2" 200 "\"category_id\":$CAT2,\"category\":{\"id\":$CAT2"
req PATCH /products/$PB '{"price":16000}';                          check "patch other field keeps category" 200 "\"category_id\":$CAT2"
req PATCH /products/$PB '{"category_id":0}';                        check "patch: category_id 0 clears it" 200 '"category_id":null'
req DELETE /categories/$CAT2;                                       check "delete unused category" 204
req GET  /categories/$CAT2;                                         check "deleted category is gone" 404
req PATCH /products/$PB "{\"category_id\":$CAT2}";                  check "assign soft-deleted category" 422 category_id

echo "== Inventory"
req GET /inventory/$PA;                                             check "no row yet: qty 0, default threshold, low" 200 "\"quantity\":0,\"low_stock_threshold\":$THRESHOLD,\"is_low_stock\":true"
req GET /inventory/999999;                                          check "inventory of missing product" 404
req POST /inventory/$PA/movements '{"type":"IN","quantity":25,"reason":"restock"}'; check "IN 25" 201 '"quantity_before":0,"quantity_after":25'
req POST /inventory/$PA/movements '{"type":"out","quantity":5}';    check "OUT 5 (lowercase type)" 201 '"quantity_before":25,"quantity_after":20'
req POST /inventory/$PA/movements '{"type":"OUT","quantity":21}';   check "OUT 21 > stock rejected" 422 'stok tidak cukup: tersedia 20'
req GET /inventory/$PA;                                             check "stock unchanged after rejected OUT" 200 '"quantity":20,'
req POST /inventory/$PA/movements '{"type":"ADJUSTMENT","quantity":7,"reason":"stock opname"}'; check "ADJUSTMENT to 7" 201 '"quantity_before":20,"quantity_after":7'
req POST /inventory/$PA/movements '{"type":"TRANSFER","quantity":1}'; check "unknown type" 422 '"field":"type"'
req POST /inventory/$PA/movements '{"type":"IN"}';                  check "missing quantity" 422 '"field":"quantity"'
req POST /inventory/$PA/movements '{"type":"IN","quantity":0}';     check "zero IN" 422
req POST /inventory/999999/movements '{"type":"IN","quantity":1}';  check "movement on missing product" 404
req GET "/inventory/$PA/movements?page=1&page_size=2";              check "movements page 1 (newest first)" 200 '"total":3'
grep -q '"type":"ADJUSTMENT".*"type":"OUT"' <<<"$body" && { pass=$((pass+1)); echo "PASS  movements ordered newest first"; } || { fail=$((fail+1)); echo "FAIL  order: $body"; }
req GET "/inventory/$PA/movements?page=2&page_size=2";              check "movements page 2" 200 '"type":"IN"'
req PATCH /inventory/$PA '{"low_stock_threshold":5}';               check "set threshold 5 -> not low (7 > 5)" 200 '"low_stock_threshold":5,"is_low_stock":false'
req PATCH /inventory/$PA '{"low_stock_threshold":-1}';              check "negative threshold" 422
req GET "/inventory/low-stock?page_size=100";                       check "low-stock list" 200
grep -q "\"product_id\":$PB," <<<"$body" && ! grep -q "\"product_id\":$PA," <<<"$body" \
  && { pass=$((pass+1)); echo "PASS  low-stock has B (no row, 0<=default), not A (7>5)"; } || { fail=$((fail+1)); echo "FAIL  low-stock content: $body"; }
req PATCH /inventory/$PA '{"low_stock_threshold":7}';               check "threshold 7 -> qty 7 is low (<=)" 200 '"is_low_stock":true'
req GET "/inventory/low-stock?page_size=100"
grep -q "\"product_id\":$PA," <<<"$body" && { pass=$((pass+1)); echo "PASS  A now in low-stock list"; } || { fail=$((fail+1)); echo "FAIL  A missing: $body"; }

echo "== Concurrency: 20 parallel OUT 1 on stock 7 -> exactly 7 succeed, stock 0"
for i in $(seq 1 20); do
  curl -s -o /dev/null -w '%{http_code}\n' -X POST "$B/inventory/$PA/movements" -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' -d '{"type":"OUT","quantity":1}' &
done > "$CODES"; wait
ok=$(grep -c '^201$' "$CODES"); rej=$(grep -c '^422$' "$CODES")
req GET /inventory/$PA
[ "$ok" = 7 ] && [ "$rej" = 13 ] && grep -q '"quantity":0,' <<<"$body" \
  && { pass=$((pass+1)); echo "PASS  201x$ok 422x$rej, final stock 0"; } || { fail=$((fail+1)); echo "FAIL  201x$ok 422x$rej $body"; }

echo "== Soft-deleted product"
req DELETE /products/$PB;                                           check "delete product B" 204
req GET /inventory/$PB;                                             check "inventory of deleted product" 404
req GET "/inventory/low-stock?page_size=100"
! grep -q "\"product_id\":$PB," <<<"$body" && { pass=$((pass+1)); echo "PASS  deleted product not in low-stock"; } || { fail=$((fail+1)); echo "FAIL  $body"; }

echo "== Customer"
req POST /customers "{\"name\":\" E2E Budi $RUN \",\"email\":\" Budi.$RUN@Example.COM \",\"phone\":\"+62 812-0000-$((RUN % 10000))\"}"
check "create customer (trimmed, email lowercased)" 201 "\"email\":\"budi.$RUN@example.com\""
CUST=$(jid)
req POST /customers "{\"name\":\"Other\",\"email\":\"BUDI.$RUN@example.com\"}"; check "duplicate email (case-insensitive)" 409
req POST /customers '{"name":"X","email":"nope","phone":"call me"}';         check "invalid email + phone" 422 '"field":"phone"'
req POST /customers "{\"name\":\"E2E NoMail $RUN\"}";                         check "email optional (null)" 201 '"email":null'
CUST2=$(jid)
req POST /customers "{\"name\":\"E2E NoMail2 $RUN\"}";                        check "second customer without email (NULLs don't collide)" 201
CUST3=$(jid)
req GET "/customers?search=budi.$RUN@example";                                check "search by email" 200 '"total":1'
req PATCH /customers/$CUST '{"address":"Jl. Merdeka 1"}';                     check "patch address" 200 '"address":"Jl. Merdeka 1"'

echo "== Sales orders: setup (P1 stock 10, P2 stock 5)"
req POST /products "{\"sku\":\"E2E-SO1-$RUN\",\"name\":\"E2E Kopi SO\",\"price\":45000}"; P1=$(jid)
req POST /products "{\"sku\":\"E2E-SO2-$RUN\",\"name\":\"E2E Teh SO\",\"price\":10000}";  P2=$(jid)
req POST /inventory/$P1/movements '{"type":"IN","quantity":10}'; check "stock P1 = 10" 201
req POST /inventory/$P2/movements '{"type":"IN","quantity":5}';  check "stock P2 = 5" 201
stock() { req GET /inventory/$1; grep -o '"quantity":[0-9]*' <<<"$body" | head -1 | cut -d: -f2; }
status_of() { req GET /sales-orders/$1; grep -o '"status":"[A-Z]*"' <<<"$body" | head -1 | cut -d'"' -f4; }

echo "== Sales orders: create (PENDING, price snapshot, no stock change)"
req POST /sales-orders "{\"customer_id\":$CUST,\"notes\":\"kirim sore\",\"items\":[{\"product_id\":$P1,\"quantity\":3},{\"product_id\":$P2,\"quantity\":2}]}"
check "create order A" 201 '"status":"PENDING","total_amount":155000'
OA=$(jid)
grep -qE '"order_number":"SO-[0-9]{8}-[0-9]{4,}"' <<<"$body" && { pass=$((pass+1)); echo "PASS  order number format"; } || { fail=$((fail+1)); echo "FAIL  order number: $body"; }
expect "PENDING does not touch stock P1" "$(stock $P1)" 10
req POST /sales-orders "{\"customer_id\":$CUST,\"items\":[{\"product_id\":$P1,\"quantity\":1},{\"product_id\":$P1,\"quantity\":2}]}"; check "duplicate product in items" 422 '"field":"items\[1\].product_id"'
req POST /sales-orders "{\"customer_id\":999999,\"items\":[{\"product_id\":$P1,\"quantity\":1}]}";                          check "unknown customer" 422 '"field":"customer_id"'
req POST /sales-orders "{\"customer_id\":$CUST,\"items\":[{\"product_id\":999999,\"quantity\":1}]}";                          check "unknown product" 422 '"field":"items\[0\].product_id"'
req POST /sales-orders "{\"customer_id\":$CUST,\"items\":[]}";                                                                check "empty items" 422 '"field":"items"'
req PATCH /products/$P1 '{"price":99000}';                                        check "raise P1 price after ordering" 200
req GET /sales-orders/$OA;                                                        check "order keeps snapshot price + total" 200 '"unit_price":45000'
grep -q '"total_amount":155000' <<<"$body" && grep -q '"customer":{"id":'"$CUST" <<<"$body" \
  && { pass=$((pass+1)); echo "PASS  detail has total, customer and items"; } || { fail=$((fail+1)); echo "FAIL  detail: $body"; }

echo "== Sales orders: state machine"
req PATCH /sales-orders/$OA/status '{"status":"SHIPPED"}';   check "PENDING -> SHIPPED rejected" 422 'yang diizinkan: CONFIRMED, CANCELLED'
req PATCH /sales-orders/$OA/status '{"status":"DELIVERED"}'; check "unknown status" 422 '"field":"status"'
req PATCH /sales-orders/$OA/status '{"status":"confirmed"}'; check "PENDING -> CONFIRMED" 200 '"status":"CONFIRMED"'
expect "CONFIRMED deducted P1 (10-3)" "$(stock $P1)" 7
expect "CONFIRMED deducted P2 (5-2)"  "$(stock $P2)" 3
req GET "/inventory/$P1/movements?page_size=1";              check "OUT movement linked to order" 200 "\"type\":\"OUT\",\"quantity\":3,\"quantity_before\":10,\"quantity_after\":7,\"reason\":\"sales order SO-"
grep -q "\"sales_order_id\":$OA" <<<"$body" && { pass=$((pass+1)); echo "PASS  movement.sales_order_id"; } || { fail=$((fail+1)); echo "FAIL  $body"; }
req PATCH /sales-orders/$OA/status '{"status":"CONFIRMED"}'; check "CONFIRMED -> CONFIRMED rejected (no double deduction)" 422
expect "stock unchanged by rejected re-confirm" "$(stock $P1)" 7

echo "== Sales orders: CONFIRMED -> CANCELLED returns stock"
req POST /sales-orders "{\"customer_id\":$CUST2,\"items\":[{\"product_id\":$P1,\"quantity\":4}]}"; OB=$(jid)
req PATCH /sales-orders/$OB/status '{"status":"CONFIRMED"}'; check "confirm order B" 200
expect "P1 after B confirmed (7-4)" "$(stock $P1)" 3
req PATCH /sales-orders/$OB/status '{"status":"CANCELLED"}'; check "cancel confirmed order B" 200 '"status":"CANCELLED"'
expect "P1 returned after cancel (3+4)" "$(stock $P1)" 7
req GET "/inventory/$P1/movements?page_size=1";              check "IN movement for the cancel" 200 '"type":"IN","quantity":4,"quantity_before":3,"quantity_after":7'
req PATCH /sales-orders/$OB/status '{"status":"CONFIRMED"}'; check "CANCELLED is final" 422 'tidak bisa diubah lagi'

echo "== Sales orders: insufficient stock rolls back every item"
req POST /sales-orders "{\"customer_id\":$CUST,\"items\":[{\"product_id\":$P1,\"quantity\":2},{\"product_id\":$P2,\"quantity\":10}]}"; OC=$(jid)
req PATCH /sales-orders/$OC/status '{"status":"CONFIRMED"}'
check "confirm with P2 short" 422 "\"field\":\"items\[1\].quantity\",\"message\":\"stok produk $P2 (E2E-SO2-$RUN) tidak cukup: tersedia 3, diminta 10\""
expect "P1 not deducted (rollback)" "$(stock $P1)" 7
expect "P2 unchanged"               "$(stock $P2)" 3
expect "order C still PENDING"      "$(status_of $OC)" PENDING

echo "== Sales orders: SHIPPED"
req PATCH /sales-orders/$OA/status '{"status":"SHIPPED"}';   check "CONFIRMED -> SHIPPED" 200 '"shipped_at":"'
expect "SHIPPED does not touch stock" "$(stock $P1)" 7
req PATCH /sales-orders/$OA/status '{"status":"CANCELLED"}'; check "SHIPPED -> CANCELLED rejected" 422

echo "== Sales orders: list"
req GET "/sales-orders?customer_id=$CUST&page_size=100";          check "filter by customer" 200 '"total":2'
req GET "/sales-orders?customer_id=$CUST&status=pending";         check "filter by customer + status" 200 '"total":1'
req GET "/sales-orders?status=LOST";                              check "bad status filter" 422
req GET "/sales-orders?customer_id=abc";                          check "bad customer_id filter" 400
req GET /sales-orders/999999;                                     check "unknown order" 404

echo "== Customer delete rules"
req DELETE /customers/$CUST;  check "customer with SHIPPED + PENDING orders" 409 'masih punya 2 pesanan yang belum dibatalkan'
req DELETE /customers/$CUST2; check "customer whose only order is CANCELLED" 204
req GET /sales-orders/$OB;    check "cancelled order still readable after customer delete" 200 "\"customer\":{\"id\":$CUST2"

echo "== Concurrency: 5 orders x 3 on stock 10, confirmed in parallel -> exactly 3 succeed"
req POST /products "{\"sku\":\"E2E-SO3-$RUN\",\"name\":\"E2E Race\",\"price\":1000}"; P3=$(jid)
req POST /inventory/$P3/movements '{"type":"IN","quantity":10}'
RACE=()
for i in 1 2 3 4 5; do
  req POST /sales-orders "{\"customer_id\":$CUST3,\"items\":[{\"product_id\":$P3,\"quantity\":3}]}"; RACE+=("$(jid)")
done
for id in "${RACE[@]}"; do
  curl -s -o /dev/null -w '%{http_code}\n' -X PATCH "$B/sales-orders/$id/status" -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' -d '{"status":"CONFIRMED"}' &
done > "$CODES"; wait
expect "confirms 200" "$(grep -c '^200$' "$CODES")" 3
expect "confirms 422" "$(grep -c '^422$' "$CODES")" 2
expect "stock left (10 - 3x3)" "$(stock $P3)" 1

echo "== Concurrency: same order confirmed 10x in parallel -> deducted once"
req POST /inventory/$P3/movements '{"type":"IN","quantity":9}'
req POST /sales-orders "{\"customer_id\":$CUST3,\"items\":[{\"product_id\":$P3,\"quantity\":2}]}"; OD=$(jid)
for i in $(seq 1 10); do
  curl -s -o /dev/null -w '%{http_code}\n' -X PATCH "$B/sales-orders/$OD/status" -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' -d '{"status":"CONFIRMED"}' &
done > "$CODES"; wait
expect "exactly one 200" "$(grep -c '^200$' "$CODES")" 1
expect "the rest 422"    "$(grep -c '^422$' "$CODES")" 9
expect "stock (10 - 2)"  "$(stock $P3)" 8

echo "== Concurrency: 20 orders created in parallel get unique numbers"
for i in $(seq 1 20); do
  curl -s -X POST "$B/sales-orders" -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
    -d "{\"customer_id\":$CUST3,\"items\":[{\"product_id\":$P3,\"quantity\":1}]}" | grep -o '"order_number":"[^"]*"' &
done > "$CODES"; wait
expect "20 created" "$(wc -l < "$CODES" | tr -d ' ')" 20
expect "20 unique numbers" "$(sort -u "$CODES" | wc -l | tr -d ' ')" 20
for id in "${RACE[@]}" $OC; do
  curl -s -o /dev/null -X PATCH "$B/sales-orders/$id/status" -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' -d '{"status":"CANCELLED"}'
done

echo "== Analytics: setup (own category, products and customer for exact numbers)"
# "Today" is the API's today: it groups sales by calendar day in APP_TIMEZONE,
# which need not be the runner's zone (a UTC runner is a day behind Jakarta
# from 17:00 to 24:00 UTC). A summary without dates ends on that day.
req GET /analytics/summary
TODAY=$(jstr to)
if [ "$code" != 200 ] || ! [[ $TODAY =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
  echo "FATAL: can't read the API's current date from GET /analytics/summary -> $code $body"
  exit 1
fi
echo "      the API's today: $TODAY"
# days_before N -> the date N days before $TODAY (noon avoids DST edges)
days_before() { date -d "$TODAY 12:00 $1 days ago" +%F; }
# field KEY [JSON] -> the first integer of KEY. An explicit empty JSON (a row
# that wasn't found) stays empty instead of falling back to the whole $body.
field() { grep -o "\"$1\":-\?[0-9]*" <<<"${2-$body}" | head -1 | cut -d: -f2; }
# The JSON object of one row, e.g. obj '"product_id":12,' -> {...}
obj() { grep -o "{[^{}]*$1[^{}]*}" <<<"${2:-$body}" | head -1; }
# pick KEY ID WHAT -> $row = the row of $body whose KEY is ID; when it is
# missing, says so (the expects that follow then fail on an empty value).
pick() {
  row=$(obj "\"$1\":$2,")
  [ -n "$row" ] || echo "      $3 ($1 $2) is not in the response for $TODAY: $body"
}

req POST /categories "{\"name\":\"E2E Analytics $RUN\"}";                                          ACAT=$(jid)
req POST /products "{\"sku\":\"E2E-AN1-$RUN\",\"name\":\"E2E Analytics Kopi\",\"price\":10000,\"category_id\":$ACAT}"; AP1=$(jid)
req POST /products "{\"sku\":\"E2E-AN2-$RUN\",\"name\":\"E2E Analytics Teh\",\"price\":25000}";      AP2=$(jid)
req POST /inventory/$AP1/movements '{"type":"IN","quantity":100}'
req POST /inventory/$AP2/movements '{"type":"IN","quantity":100}'
req POST /customers "{\"name\":\"E2E Analytics Cust $RUN\"}";                                       ACUST=$(jid)

# Baseline before our orders (this call may also populate the summary cache).
req GET "/analytics/summary?from=$TODAY&to=$TODAY"; check "summary baseline" 200 '"total_revenue"'
BASE_REV=$(field total_revenue); BASE_ORDERS=$(field total_orders); BASE_ITEMS=$(field total_items_sold)

echo "== Analytics: orders (2 sold, 1 pending, 1 cancelled)"
order() { # items-json -> OID
  req POST /sales-orders "{\"customer_id\":$ACUST,\"items\":$1}"
  jid
}
# Sold: 3x10000 + 1x25000 = 55000
O1=$(order "[{\"product_id\":$AP1,\"quantity\":3},{\"product_id\":$AP2,\"quantity\":1}]")
req PATCH /sales-orders/$O1/status '{"status":"CONFIRMED"}'; check "analytics order 1 confirmed" 200
# Sold: 2x25000 = 50000, then shipped (still a sale)
O2=$(order "[{\"product_id\":$AP2,\"quantity\":2}]")
req PATCH /sales-orders/$O2/status '{"status":"CONFIRMED"}'; check "analytics order 2 confirmed" 200
req PATCH /sales-orders/$O2/status '{"status":"SHIPPED"}';   check "analytics order 2 shipped" 200
# Not a sale: stays PENDING (50000)
O3=$(order "[{\"product_id\":$AP1,\"quantity\":5}]")
# Not a sale: confirmed then cancelled (20000)
O4=$(order "[{\"product_id\":$AP1,\"quantity\":2}]")
req PATCH /sales-orders/$O4/status '{"status":"CONFIRMED"}'; check "analytics order 4 confirmed" 200
req PATCH /sales-orders/$O4/status '{"status":"CANCELLED"}'; check "analytics order 4 cancelled" 200
# Expected from the two sold orders only: revenue 105000, 2 orders, 6 items.

echo "== Analytics: top products (not cached, so exact)"
req GET "/analytics/top-products?from=$TODAY&to=$TODAY&limit=50"; check "top-products" 200 '"products"'
pick product_id "$AP1" "e2e product AP1"
expect "AP1 quantity (3 sold; 5 pending + 2 cancelled ignored)" "$(field quantity_sold "$row")" 3
expect "AP1 revenue" "$(field revenue "$row")" 30000
pick product_id "$AP2" "e2e product AP2"
expect "AP2 quantity (1 + 2 from two sold orders)" "$(field quantity_sold "$row")" 3
expect "AP2 revenue" "$(field revenue "$row")" 75000
grep -q "\"sku\":\"E2E-AN1-$RUN\"" <<<"$body" && { pass=$((pass+1)); echo "PASS  top-products carries the item snapshot SKU"; } || { fail=$((fail+1)); echo "FAIL  $body"; }

echo "== Analytics: category breakdown (not cached, so exact)"
req GET "/analytics/category-breakdown?from=$TODAY&to=$TODAY"; check "category-breakdown" 200 '"categories"'
pick category_id "$ACAT" "e2e category"
expect "our category revenue (only AP1)" "$(field revenue "$row")" 30000
expect "our category quantity"           "$(field quantity_sold "$row")" 3
grep -q '"category_id":null' <<<"$body" && { pass=$((pass+1)); echo "PASS  products without a category are grouped separately"; } || { fail=$((fail+1)); echo "FAIL  no null category bucket: $body"; }

echo "== Analytics: summary and trend (cached; deltas are checked against the baseline)"
req GET "/analytics/summary?from=$TODAY&to=$TODAY"; check "summary" 200 '"average_order_value"'
DELTA_REV=$(( $(field total_revenue) - BASE_REV ))
DELTA_ORDERS=$(( $(field total_orders) - BASE_ORDERS ))
DELTA_ITEMS=$(( $(field total_items_sold) - BASE_ITEMS ))
if [ "$DELTA_REV" = 0 ] && [ "$DELTA_ORDERS" = 0 ]; then
  pass=$((pass+1))
  echo "PASS  summary served from cache (unchanged within the TTL)"
  echo "      note: restart the API with ANALYTICS_CACHE_TTL=0 to assert fresh summary/trend numbers"
else
  expect "summary revenue delta (only CONFIRMED + SHIPPED)" "$DELTA_REV" 105000
  expect "summary orders delta"                             "$DELTA_ORDERS" 2
  expect "summary items delta"                              "$DELTA_ITEMS" 6
  req GET "/analytics/sales-trend?from=$TODAY&to=$TODAY&granularity=daily"
  point=$(obj "\"period_start\":\"$TODAY\"")
  [ -n "$point" ] && { pass=$((pass+1)); echo "PASS  trend has a point for today"; } || { fail=$((fail+1)); echo "FAIL  no point for $TODAY: $body"; }
fi

echo "== Analytics: trend shape and other endpoints"
WEEK_AGO=$(days_before 6)
req GET "/analytics/sales-trend?from=$WEEK_AGO&to=$TODAY&granularity=daily"; check "trend daily" 200 '"granularity":"daily"'
expect "7 daily points, gaps filled with zeros" "$(grep -o '"period_start"' <<<"$body" | wc -l | tr -d ' ')" 7
req GET "/analytics/sales-trend?from=$WEEK_AGO&to=$TODAY&granularity=weekly"; check "trend weekly" 200 '"granularity":"weekly"'
req GET "/analytics/summary";      check "summary defaults to the last 30 days" 200 '"from"'
req GET "/inventory/low-stock?page_size=1"; LOW_TOTAL=$(field total)
req GET /analytics/low-stock-alert-count;   check "low-stock-alert-count" 200 '"count"'
expect "alert count matches /inventory/low-stock" "$(field count)" "$LOW_TOTAL"

echo "== Analytics: validation"
req GET "/analytics/summary?from=2026-13-01";                     check "bad date format" 422 '"field":"from"'
req GET "/analytics/summary?from=$TODAY&to=2020-01-01";           check "from after to" 422 '"field":"from"'
req GET "/analytics/summary?from=2020-01-01&to=$TODAY";           check "range longer than a year" 422 '"field":"to"'
req GET "/analytics/sales-trend?granularity=hourly";              check "bad granularity" 422 '"field":"granularity"'

echo "== Analytics: forecast and insights (Python ML service)"
# Run this script once with the ML service up and once with it stopped: the
# branch below asserts the happy path or the graceful degradation accordingly.
ML=${ML_SERVICE_URL:-http://localhost:8000}
if curl -s -m 3 -o /dev/null -w '%{http_code}' "$ML/health" | grep -q 200; then
  echo "      ML service reachable at $ML"
  req GET "/analytics/forecast?limit=3&horizon_days=7";  check "forecast" 200 '"forecast_available":true'
  expect "3 products forecast"      "$(grep -o '"product_id"' <<<"$body" | wc -l | tr -d ' ')" 3
  expect "7 predicted days for the first product" "$(grep -o '"predicted_quantity"' <<<"$body" | wc -l | tr -d ' ')" 21
  check "forecast method is reported" 200 '"method":"moving_average"'
  check "no product carries an error" 200 '"products"'
  grep -q '"error"' <<<"$body" \
    && { fail=$((fail+1)); echo "FAIL  a product failed while the ML service is up: $body"; } \
    || { pass=$((pass+1)); echo "PASS  every product forecast succeeded"; }

  req GET "/analytics/insights?limit=3"; check "insights" 200 '"insights_available":true'
  check "insight has an Indonesian summary" 200 '"summary":"Penjualan'
  check "insight has a trend direction"     200 '"trend":"'

  req GET "/analytics/forecast?from=$TODAY&to=$TODAY"; check "range too short to forecast" 422 '"field":"from"'
else
  echo "      ML service NOT reachable at $ML -> checking graceful degradation"
  # A range the happy path never uses: a successful report cached earlier
  # (FORECAST_CACHE_TTL) would otherwise be served and hide the outage.
  # Degraded reports are never cached, so this key stays empty.
  DEGRADED="from=$(days_before 25)&to=$TODAY"
  req GET "/analytics/forecast?$DEGRADED&limit=3"
  check "forecast still answers 200 while the ML service is down" 200 '"forecast_available":false'
  check "each product carries its own error"                      200 '"error":"layanan forecasting sedang tidak tersedia"'
  req GET "/analytics/insights?$DEGRADED&limit=3"
  check "insights still answer 200 while the ML service is down"  200 '"insights_available":false'
  req GET "/analytics/summary?from=$TODAY&to=$TODAY"
  check "the rest of analytics is unaffected by the ML outage"    200 '"total_revenue"'
fi

echo "== i18n: the same rules in Indonesian and in English"
# Default (no header) must stay Indonesian: clients that send no
# Accept-Language, like the current Flutter app, keep working unchanged.
req POST /products '{"sku":"","name":"","price":-1}'
check "validation in Indonesian by default" 422 '"message":"wajib diisi"'
req POST /categories "{\"name\":\"E2E Minuman $RUN\"}"
check "duplicate category in Indonesian"    409 'sudah ada'

LANG_HEADER=en
req POST /products '{"sku":"","name":"","price":-1}'
check "validation in English"               422 '"message":"is required"'
check "field names are never translated"    422 '"field":"sku"'
req POST /products "{\"sku\":\"E2E-A-$RUN\",\"name\":\"E2E Kopi\",\"price\":45000}"
check "duplicate SKU in English"            409 'already exists'
req POST /inventory/$PA/movements '{"type":"OUT","quantity":999999,"reason":"e2e i18n"}'
check "insufficient stock in English"       422 'available, .* requested'
req GET /products/999999
check "not found in English"                404 'not found'
req GET "/analytics/summary?from=2026-13-01"
check "analytics validation in English"     422 'must be a date in YYYY-MM-DD format'
req PATCH /sales-orders/$OB/status '{"status":"PENDING"}'
check "invalid transition in English"       422 "can't change status"

LANG_HEADER=en-US,en
req GET /products/999999
check "browser-style Accept-Language"       404 'not found'
LANG_HEADER=fr
req GET /products/999999
check "unsupported language falls back to Indonesian" 404 'tidak ditemukan'
unset LANG_HEADER

if curl -s -m 3 -o /dev/null -w '%{http_code}' "${ML_SERVICE_URL:-http://localhost:8000}/health" | grep -q 200; then
  LANG_HEADER=en
  req GET "/analytics/insights?limit=2"
  check "insight summary in English"        200 '"summary":"Sales '
  LANG_HEADER=id
  req GET "/analytics/insights?limit=2&from=$(days_before 20)&to=$TODAY"
  check "insight summary in Indonesian"     200 '"summary":"Penjualan'
  unset LANG_HEADER
fi

echo "== Cleanup (soft delete; stock_movements are immutable and stay)"
req DELETE /products/$PA;   check "delete product A" 204
req DELETE /categories/$CAT; check "category deletable once products are gone" 204
req DELETE /users/$STAFF_USER; check "delete the e2e Staff user" 204
as "$STAFF" GET /products;     check "a deleted user's token stops working" 401

echo "== Guardrail: at least one active Super Admin always remains"
# Through the API the last Super Admin can only be removed by a race: nobody
# may demote themselves, and only a Super Admin may demote a Super Admin, so
# with one left there is nobody who could. With two, A demoting B while B
# demotes A is the real danger — each request alone is legal. The service
# locks every Super Admin row before counting, so one of them must lose.
# Run several rounds; each round restores both accounts afterwards.
ADMIN2_EMAIL="e2e.admin2.$RUN@example.test"
req POST /users "{\"email\":\"$ADMIN2_EMAIL\",\"password\":\"rahasia123\",\"name\":\"E2E Admin2 $RUN\",\"role_id\":$ADMIN_ROLE}"
check "create a second Super Admin" 201; ADMIN2=$(jid)
login "$ADMIN2_EMAIL" rahasia123; B_TOKEN=$ACCESS
race_ok=0; race_409=0
for round in 1 2 3 4 5; do
  curl -s -o /dev/null -w 'A %{http_code}\n' -X PATCH "$B/users/$ADMIN2" -H "Authorization: Bearer $TOKEN" \
    -H 'Content-Type: application/json' -d "{\"role_id\":$STAFF_ROLE}" > "$CODES.a" &
  curl -s -o /dev/null -w 'B %{http_code}\n' -X PATCH "$B/users/$ADMIN_ID" -H "Authorization: Bearer $B_TOKEN" \
    -H 'Content-Type: application/json' -d "{\"role_id\":$STAFF_ROLE}" > "$CODES.b" &
  wait
  a=$(cut -d' ' -f2 "$CODES.a"); b=$(cut -d' ' -f2 "$CODES.b")
  # Count who is still Super Admin, as the database sees it.
  req GET "/users?role_id=$ADMIN_ROLE&page_size=100"
  [ "$code" = 200 ] || { as "$B_TOKEN" GET "/users?role_id=$ADMIN_ROLE&page_size=100"; }
  a_admin=$(grep -o "{\"id\":$ADMIN_ID,\"email\"" <<<"$body" | wc -l | tr -d " "); b_admin=$(grep -o "{\"id\":$ADMIN2,\"email\"" <<<"$body" | wc -l | tr -d " ")
  winners=$(( (a == 200) + (b == 200) ))
  if [ "$winners" = 1 ] && [ $((a_admin + b_admin)) = 1 ]; then
    race_ok=$((race_ok+1)); { [ "$a" = 409 ] || [ "$b" = 409 ]; } && race_409=$((race_409+1))
    echo "      round $round: A->$a B->$b, one Super Admin left"
  else
    echo "      round $round: A->$a B->$b, Super Admins left: A=$a_admin B=$b_admin (WRONG)"
  fi
  # Restore both: whoever is still Super Admin re-promotes the other.
  if [ "$a_admin" = 1 ]; then as "$TOKEN" PATCH /users/$ADMIN2 "{\"role_id\":$ADMIN_ROLE}"; else as "$B_TOKEN" PATCH /users/$ADMIN_ID "{\"role_id\":$ADMIN_ROLE}"; fi
done
rm -f "$CODES.a" "$CODES.b"
expect "every round: exactly one demotion won, one Super Admin remained" "$race_ok" 5
echo "      ($race_409 of 5 rounds were decided by the lock -> 409, the rest by the loser's permission check -> 403."
echo "       HTTP timing rarely overlaps enough to reach the lock; TestGuardrail_TwoSuperAdminsDemotingEachOther proves it deterministically.)"
req GET /auth/me;                                         check "the main admin is Super Admin again" 200 '"is_system":true'
req PATCH /users/$ADMIN2 '{"is_active":false}';           check "deactivating one of two Super Admins is allowed" 200
login "$ADMIN2_EMAIL" rahasia123;                         check "the deactivated admin can't log in" 401
req DELETE /users/$ADMIN2;                                check "remove the second Super Admin" 204

echo "== Cleanup: this run's users and roles (hard delete)"
# The API can't remove roles this run's soft-deleted users still reference
# (409, tested above), so they are removed in the database, scoped to this
# run only. E2E_SKIP_CLEANUP=1 keeps them for inspection.
if [ -n "$E2E_SKIP_CLEANUP" ]; then
  echo "      skipped (E2E_SKIP_CLEANUP); later: go run ./cmd/seed --clean-e2e-run=$RUN"
else
  if (cd "$(dirname "$0")/.." && go run ./cmd/seed --clean-e2e-run="$RUN") >"$CODES" 2>&1; then
    pass=$((pass+1)); echo "PASS  go run ./cmd/seed --clean-e2e-run=$RUN"
  else
    fail=$((fail+1)); echo "FAIL  cleanup:"; sed 's/^/      /' "$CODES"
  fi
  req GET "/roles?search=$RUN&page_size=100";             check "no role of this run is left" 200 '"total":0'
  req GET "/users?search=.$RUN@example.test";             check "no user of this run is left" 200 '"total":0'
fi

echo; echo "RESULT: $pass passed, $fail failed  (products $PA,$PB,$P1,$P2,$P3 categories $CAT,$CAT2 customers $CUST,$CUST2,$CUST3 orders $OA,$OB,$OC,$OD)"
[ "$fail" -eq 0 ]
