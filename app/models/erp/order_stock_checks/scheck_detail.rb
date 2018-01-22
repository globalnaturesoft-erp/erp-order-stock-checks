module Erp::OrderStockChecks
  class ScheckDetail < ApplicationRecord
    belongs_to :scheck, class_name: 'Erp::OrderStockChecks::Scheck'
    belongs_to :order_detail, class_name: 'Erp::Orders::OrderDetail'

    def get_alternative_item_ids
      return [] if !self.alternative_items.present?

      items = JSON.parse(self.alternative_items).reject(&:empty?)
      items = items.collect {|item| item.to_i}
    end

    # get alternative items / products list
    def get_alternative_items
      ids = get_alternative_item_ids
      items = Erp::Products::Product.where(id: ids)
      return items
    end

    # get alternative item names / product names list
    def get_alternative_item_names
      return get_alternative_items.map(&:name)
    end
  end
end
