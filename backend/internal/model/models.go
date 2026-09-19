// Package model holds GORM entities and the input/param types passed between layers.
package model

// All returns every entity managed by migrations. Add new models here,
// referenced tables before the tables that point to them.
func All() []any {
	return []any{
		&Category{},
		&Product{},
		&Inventory{},
		&Customer{},
		&SalesOrder{},
		&SalesOrderItem{},
		&SalesOrderCounter{},
		&StockMovement{}, // references sales_orders

	}
}
