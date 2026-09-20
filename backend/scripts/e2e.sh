#!/usr/bin/env bash
# Smoke test for the Category + Inventory endpoints against a running API.
#
# Usage (API running, migrations applied):
#   bash scripts/e2e.sh
#   API_URL=http://localhost:9000/api/v1 LOW_STOCK_DEFAULT_THRESHOLD=5 bash scripts/e2e.sh
#
# LOW_STOCK_DEFAULT_THRESHOLD must match the API's value (default 10).
# Every run uses unique names/SKUs, so it can be re-run against the same DB.
# Created products/categories are soft-deleted at the end. Their
# stock_movements and inventories rows stay, because movements are immutable.
# Exits 1 if any check fails.
B=${API_URL:-http://localhost:8080/api/v1}
THRESHOLD=${LOW_STOCK_DEFAULT_THRESHOLD:-10}
RUN=$(date +%s)
CODES=$(mktemp); trap 'rm -f "$CODES"' EXIT
pass=0; fail=0

# req METHOD PATH [BODY] -> sets $code and $body
req() {
  local out
  if [ -n "$3" ]; then
    out=$(curl -s -w $'\n%{http_code}' -X "$1" "$B$2" -H 'Content-Type: application/json' -d "$3")
  else
    out=$(curl -s -w $'\n%{http_code}' -X "$1" "$B$2")
  fi
  code=${out##*$'\n'}; body=${out%$'\n'*}
}
check() { # label expected-code [grep-pattern]
  if [ "$code" = "$2" ] && { [ -z "$3" ] || grep -q -- "$3" <<<"$body"; }; then
    pass=$((pass+1)); echo "PASS  $1 -> $code"
  else
    fail=$((fail+1)); echo "FAIL  $1 -> $code (want $2 ${3:+/ $3})"; echo "      $body"
  fi
}
jid() { grep -o '"id":[0-9]*' <<<"$body" | head -1 | cut -d: -f2; }

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
req DELETE /categories/$CAT;                                        check "delete category in use" 409 "used by 1 product"
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
req POST /inventory/$PA/movements '{"type":"OUT","quantity":21}';   check "OUT 21 > stock rejected" 422 'insufficient stock: 20 available'
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
  curl -s -o /dev/null -w '%{http_code}\n' -X POST "$B/inventory/$PA/movements" -H 'Content-Type: application/json' -d '{"type":"OUT","quantity":1}' &
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
expect() { # label actual expected
  [ "$2" = "$3" ] && { pass=$((pass+1)); echo "PASS  $1 ($2)"; } || { fail=$((fail+1)); echo "FAIL  $1: got '$2', want '$3'"; }
}
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
req PATCH /sales-orders/$OA/status '{"status":"SHIPPED"}';   check "PENDING -> SHIPPED rejected" 422 'allowed: CONFIRMED, CANCELLED'
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
req PATCH /sales-orders/$OB/status '{"status":"CONFIRMED"}'; check "CANCELLED is final" 422 "can't change status anymore"

echo "== Sales orders: insufficient stock rolls back every item"
req POST /sales-orders "{\"customer_id\":$CUST,\"items\":[{\"product_id\":$P1,\"quantity\":2},{\"product_id\":$P2,\"quantity\":10}]}"; OC=$(jid)
req PATCH /sales-orders/$OC/status '{"status":"CONFIRMED"}'
check "confirm with P2 short" 422 "\"field\":\"items\[1\].quantity\",\"message\":\"insufficient stock for product $P2 (E2E-SO2-$RUN): 3 available, 10 requested\""
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
req DELETE /customers/$CUST;  check "customer with SHIPPED + PENDING orders" 409 'still has 2 sales order(s) that are not cancelled'
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
  curl -s -o /dev/null -w '%{http_code}\n' -X PATCH "$B/sales-orders/$id/status" -H 'Content-Type: application/json' -d '{"status":"CONFIRMED"}' &
done > "$CODES"; wait
expect "confirms 200" "$(grep -c '^200$' "$CODES")" 3
expect "confirms 422" "$(grep -c '^422$' "$CODES")" 2
expect "stock left (10 - 3x3)" "$(stock $P3)" 1

echo "== Concurrency: same order confirmed 10x in parallel -> deducted once"
req POST /inventory/$P3/movements '{"type":"IN","quantity":9}'
req POST /sales-orders "{\"customer_id\":$CUST3,\"items\":[{\"product_id\":$P3,\"quantity\":2}]}"; OD=$(jid)
for i in $(seq 1 10); do
  curl -s -o /dev/null -w '%{http_code}\n' -X PATCH "$B/sales-orders/$OD/status" -H 'Content-Type: application/json' -d '{"status":"CONFIRMED"}' &
done > "$CODES"; wait
expect "exactly one 200" "$(grep -c '^200$' "$CODES")" 1
expect "the rest 422"    "$(grep -c '^422$' "$CODES")" 9
expect "stock (10 - 2)"  "$(stock $P3)" 8

echo "== Concurrency: 20 orders created in parallel get unique numbers"
for i in $(seq 1 20); do
  curl -s -X POST "$B/sales-orders" -H 'Content-Type: application/json' \
    -d "{\"customer_id\":$CUST3,\"items\":[{\"product_id\":$P3,\"quantity\":1}]}" | grep -o '"order_number":"[^"]*"' &
done > "$CODES"; wait
expect "20 created" "$(wc -l < "$CODES" | tr -d ' ')" 20
expect "20 unique numbers" "$(sort -u "$CODES" | wc -l | tr -d ' ')" 20
for id in "${RACE[@]}" $OC; do
  curl -s -o /dev/null -X PATCH "$B/sales-orders/$id/status" -H 'Content-Type: application/json' -d '{"status":"CANCELLED"}'
done

echo "== Analytics: setup (own category, products and customer for exact numbers)"
TODAY=$(date +%F)
field() { grep -o "\"$1\":-\?[0-9]*" <<<"${2:-$body}" | head -1 | cut -d: -f2; }
# The JSON object of one row, e.g. obj '"product_id":12' -> {...}
obj() { grep -o "{[^{}]*$1[^{}]*}" <<<"${2:-$body}" | head -1; }

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
row=$(obj "\"product_id\":$AP1")
expect "AP1 quantity (3 sold; 5 pending + 2 cancelled ignored)" "$(field quantity_sold "$row")" 3
expect "AP1 revenue" "$(field revenue "$row")" 30000
row=$(obj "\"product_id\":$AP2")
expect "AP2 quantity (1 + 2 from two sold orders)" "$(field quantity_sold "$row")" 3
expect "AP2 revenue" "$(field revenue "$row")" 75000
grep -q "\"sku\":\"E2E-AN1-$RUN\"" <<<"$body" && { pass=$((pass+1)); echo "PASS  top-products carries the item snapshot SKU"; } || { fail=$((fail+1)); echo "FAIL  $body"; }

echo "== Analytics: category breakdown (not cached, so exact)"
req GET "/analytics/category-breakdown?from=$TODAY&to=$TODAY"; check "category-breakdown" 200 '"categories"'
row=$(obj "\"category_id\":$ACAT")
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
WEEK_AGO=$(date -d '-6 days' +%F)
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

echo "== Cleanup (soft delete; stock_movements are immutable and stay)"
req DELETE /products/$PA;   check "delete product A" 204
req DELETE /categories/$CAT; check "category deletable once products are gone" 204

echo; echo "RESULT: $pass passed, $fail failed  (products $PA,$PB,$P1,$P2,$P3 categories $CAT,$CAT2 customers $CUST,$CUST2,$CUST3 orders $OA,$OB,$OC,$OD)"
[ "$fail" -eq 0 ]
