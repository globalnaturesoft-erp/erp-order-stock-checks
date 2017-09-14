class CreateErpOrderStockChecksScheckDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_order_stock_checks_scheck_details do |t|
      t.references :scheck, index: true, references: :erp_order_stock_checks_schecks
      t.references :order_detail, index: true, references: :erp_orders_order_details
      t.boolean :available, default: false
      t.string :alternative_items
      t.text :note

      t.timestamps
    end
  end
end
