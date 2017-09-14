class CreateErpOrderStockChecksSchecks < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_order_stock_checks_schecks do |t|
      t.string :code
      t.string :status
      t.references :order, index: true, references: :erp_orders_orders
      t.references :employee, index: true, references: :erp_users
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
