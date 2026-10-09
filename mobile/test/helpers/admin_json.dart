// Responses captured from the running Go API (port 8090, seeded database)
// on 2026-10-09, byte for byte — not written from memory. Fixture rows were
// created for the capture by a Super Admin and a "user manager" role
// (users.view/create/update + the "E2E Gudang" role's permissions), then
// removed with `go run ./cmd/seed --clean-e2e-run`.
//
// Shared by test/contract/admin_json_contract_test.dart (the shapes) and the
// HTTP-level role list test (what one screen load requests).

/// admin POST /roles → HTTP 201
const adminPostRole = r'''{"data":{"id":172,"name":"E2E Baru 1791539033","description":"","is_system":false,"user_count":0,"created_at":"2026-10-09T16:43:54.4134481+07:00","updated_at":"2026-10-09T16:43:54.4134481+07:00","permissions":[]}}''';

/// admin GET /roles?page=1&page_size=100 → HTTP 200
const adminGetRoles = r'''{"data":[{"id":1,"name":"Super Admin","description":"Akses penuh ke seluruh sistem, termasuk pengguna dan role. Tidak bisa dihapus.","is_system":true,"user_count":1,"created_at":"2026-09-30T18:34:57.982556+07:00","updated_at":"2026-09-30T18:34:57.982556+07:00","permissions":["products.view","products.create","products.update","products.delete","categories.view","categories.create","categories.update","categories.delete","inventory.view","inventory.update","inventory.record_movement","customers.view","customers.create","customers.update","customers.delete","sales_orders.view","sales_orders.create","sales_orders.confirm","sales_orders.ship","sales_orders.cancel","analytics.view","analytics.forecast","analytics.insights","users.view","users.create","users.update","users.delete","roles.view","roles.create","roles.update","roles.delete","roles.assign_permissions"]},{"id":172,"name":"E2E Baru 1791539033","description":"","is_system":false,"user_count":0,"created_at":"2026-10-09T16:43:54.413448+07:00","updated_at":"2026-10-09T16:43:54.413448+07:00","permissions":[]},{"id":170,"name":"E2E Gudang 1791539033","description":"stok saja","is_system":false,"user_count":2,"created_at":"2026-10-09T16:43:53.420712+07:00","updated_at":"2026-10-09T16:43:53.552933+07:00","permissions":["products.view","inventory.view","inventory.record_movement"]},{"id":171,"name":"E2E UserMgr 1791539033","description":"","is_system":false,"user_count":1,"created_at":"2026-10-09T16:43:53.667506+07:00","updated_at":"2026-10-09T16:43:53.769243+07:00","permissions":["products.view","inventory.view","inventory.record_movement","users.view","users.create","users.update"]},{"id":2,"name":"Staff","description":"Staf operasional: melihat semua data, membuat dan memproses pesanan.","is_system":false,"user_count":1,"created_at":"2026-09-30T18:34:57.987667+07:00","updated_at":"2026-09-30T18:34:57.990287+07:00","permissions":["products.view","categories.view","inventory.view","customers.view","sales_orders.view","sales_orders.create","sales_orders.confirm","sales_orders.ship","sales_orders.cancel","analytics.view","analytics.forecast","analytics.insights"]}],"meta":{"page":1,"page_size":100,"total":5}}''';

/// admin GET /roles/170 → HTTP 200
const adminGetRole = r'''{"data":{"id":170,"name":"E2E Gudang 1791539033","description":"stok saja","is_system":false,"user_count":2,"created_at":"2026-10-09T16:43:53.420712+07:00","updated_at":"2026-10-09T16:43:53.552933+07:00","permissions":["products.view","inventory.view","inventory.record_movement"]}}''';

/// admin DELETE /roles/170 (in use → HTTP 409
const deleteRoleInUseId = r'''{"error":{"code":"conflict","message":"role 170 masih terhubung dengan 2 pengguna (termasuk yang sudah dihapus)"}}''';

/// admin DELETE /roles/170 en → HTTP 409
const deleteRoleInUseEn = r'''{"error":{"code":"conflict","message":"role 170 is still linked to 2 user(s), including deleted ones"}}''';

/// admin GET /users?search= → HTTP 200
const adminGetUsers = r'''{"data":[{"id":223,"email":"e2e.g1.1791539033@example.test","name":"E2E Gudang1 1791539033","role_id":170,"role":{"id":170,"name":"E2E Gudang 1791539033","description":"stok saja","is_system":false,"created_at":"2026-10-09T16:43:53.420712+07:00","updated_at":"2026-10-09T16:43:53.552933+07:00","permissions":null},"is_active":true,"created_at":"2026-10-09T16:43:54.094167+07:00","updated_at":"2026-10-09T16:43:54.094167+07:00"},{"id":222,"email":"e2e.um.1791539033@example.test","name":"E2E UM 1791539033","role_id":171,"role":{"id":171,"name":"E2E UserMgr 1791539033","description":"","is_system":false,"created_at":"2026-10-09T16:43:53.667506+07:00","updated_at":"2026-10-09T16:43:53.769243+07:00","permissions":null},"is_active":true,"created_at":"2026-10-09T16:43:53.932689+07:00","updated_at":"2026-10-09T16:43:53.932689+07:00"}],"meta":{"page":1,"page_size":20,"total":2}}''';

/// user manager GET /roles?page=1&page_size=100 → HTTP 200
const managerGetRoles = r'''{"data":[{"id":1,"name":"Super Admin","description":"Akses penuh ke seluruh sistem, termasuk pengguna dan role. Tidak bisa dihapus.","is_system":true,"user_count":1,"created_at":"2026-09-30T18:34:57.982556+07:00","updated_at":"2026-09-30T18:34:57.982556+07:00","permissions":["products.view","products.create","products.update","products.delete","categories.view","categories.create","categories.update","categories.delete","inventory.view","inventory.update","inventory.record_movement","customers.view","customers.create","customers.update","customers.delete","sales_orders.view","sales_orders.create","sales_orders.confirm","sales_orders.ship","sales_orders.cancel","analytics.view","analytics.forecast","analytics.insights","users.view","users.create","users.update","users.delete","roles.view","roles.create","roles.update","roles.delete","roles.assign_permissions"]},{"id":172,"name":"E2E Baru 1791539033","description":"","is_system":false,"user_count":0,"created_at":"2026-10-09T16:43:54.413448+07:00","updated_at":"2026-10-09T16:43:54.413448+07:00","permissions":[]},{"id":170,"name":"E2E Gudang 1791539033","description":"stok saja","is_system":false,"user_count":2,"created_at":"2026-10-09T16:43:53.420712+07:00","updated_at":"2026-10-09T16:43:53.552933+07:00","permissions":["products.view","inventory.view","inventory.record_movement"]},{"id":171,"name":"E2E UserMgr 1791539033","description":"","is_system":false,"user_count":1,"created_at":"2026-10-09T16:43:53.667506+07:00","updated_at":"2026-10-09T16:43:53.769243+07:00","permissions":["products.view","inventory.view","inventory.record_movement","users.view","users.create","users.update"]},{"id":2,"name":"Staff","description":"Staf operasional: melihat semua data, membuat dan memproses pesanan.","is_system":false,"user_count":1,"created_at":"2026-09-30T18:34:57.987667+07:00","updated_at":"2026-09-30T18:34:57.990287+07:00","permissions":["products.view","categories.view","inventory.view","customers.view","sales_orders.view","sales_orders.create","sales_orders.confirm","sales_orders.ship","sales_orders.cancel","analytics.view","analytics.forecast","analytics.insights"]}],"meta":{"page":1,"page_size":100,"total":5}}''';

/// user manager GET /roles/170 → HTTP 403
const managerGetRole = r'''{"error":{"code":"forbidden","message":"anda tidak punya izin roles.view"}}''';

/// user manager GET /permissions → HTTP 403
const managerGetPermissions = r'''{"error":{"code":"forbidden","message":"anda tidak punya izin roles.view"}}''';

/// user manager POST /users with Staff (exceeds) → HTTP 403
const managerAssignStaffId = r'''{"error":{"code":"forbidden","message":"tidak bisa memberikan role \"Staff\" karena role itu punya izin \"categories.view\" yang tidak anda miliki sendiri"}}''';

/// user manager POST /users with Staff en → HTTP 403
const managerAssignStaffEn = r'''{"error":{"code":"forbidden","message":"you can't assign the \"Staff\" role because it has the \"categories.view\" permission, which you don't hold yourself"}}''';

/// user manager POST /users with Gudang (allowed) → HTTP 201
const managerCreateGudang = r'''{"data":{"id":225,"email":"e2e.ok.1791539033@example.test","name":"E2E Ok 1791539033","role_id":170,"role":{"id":170,"name":"E2E Gudang 1791539033","description":"stok saja","is_system":false,"user_count":2,"created_at":"2026-10-09T16:43:53.420712+07:00","updated_at":"2026-10-09T16:43:53.552933+07:00","permissions":["products.view","inventory.view","inventory.record_movement"]},"is_active":true,"created_at":"2026-10-09T16:43:55.2840313+07:00","updated_at":"2026-10-09T16:43:55.2840313+07:00"}}''';

/// user manager PATCH staff@example.com → HTTP 403
const managerPatchStaff = r'''{"error":{"code":"forbidden","message":"tidak bisa mengubah atau menghapus pengguna dengan role \"Staff\" karena role itu punya izin \"categories.view\" yang tidak anda miliki sendiri"}}''';

/// user manager DELETE staff user → HTTP 403
const managerDeleteNoPerm = r'''{"error":{"code":"forbidden","message":"anda tidak punya izin users.delete"}}''';

/// user manager PATCH Super Admin → HTTP 403
const managerPatchSuperAdmin = r'''{"error":{"code":"forbidden","message":"hanya Super Admin yang bisa memberikan role sistem atau mengubah akun Super Admin"}}''';
