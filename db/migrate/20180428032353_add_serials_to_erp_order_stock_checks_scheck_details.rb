class AddSerialsToErpOrderStockChecksScheckDetails < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_order_stock_checks_scheck_details, :serials, :string
  end
end
