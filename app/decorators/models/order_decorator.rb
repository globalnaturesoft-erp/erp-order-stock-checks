Erp::Orders::Order.class_eval do
    # get waiting checking order count
    def self.stock_check_orders_count
        self.stock_check_orders.count
    end

    # get waiting checking order count
    def self.stock_checking_orders_count
        self.stock_checking_orders.count
    end
end
