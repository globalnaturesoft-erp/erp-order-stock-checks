module Erp::OrderStockChecks
  class ScheckDetail < ApplicationRecord
    belongs_to :scheck, class_name: 'Erp::OrderStockChecks::Scheck'
    belongs_to :order_detail, class_name: 'Erp::Orders::OrderDetail'

    # get alternative items / products list
    def get_alternative_items
      return [] if !self.alternative_items.present?

      arr = []

      rows = JSON.parse(self.alternative_items.gsub('=>', ':'))
      # return rows
      rows.each do |row|
        data = row[1]
        if data.present?
          if data['check'].present? and data['check'] != 'false'
            arr << {
              product: Erp::Products::Product.find(data['product_id']),
              serials: data['serials'],
              index: data['index'],
            }
          end
        end
      end

      return arr
    end

    # get alternative ids
    def get_alternative_ids
      return (get_alternative_items.map{|item| item[:product].id})
    end

    # get alternative ids
    def get_alternative_serials_by_product_id(product_id)
      items = (get_alternative_items.select{|item| item[:product].id == product_id})
      return (items.empty? ? nil : items.first[:serials])
    end
  end
end
