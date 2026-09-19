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

echo "== Cleanup (soft delete; stock_movements are immutable and stay)"
req DELETE /products/$PA;   check "delete product A" 204
req DELETE /categories/$CAT; check "category deletable once products are gone" 204

echo; echo "RESULT: $pass passed, $fail failed  (products $PA,$PB categories $CAT,$CAT2)"
[ "$fail" -eq 0 ]
