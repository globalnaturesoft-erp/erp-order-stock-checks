Erp::Ability.class_eval do
  def order_stock_checks_ability(user)
    
    # Create for stock check (if stock check not exist)
    can :stock_check, Erp::Orders::Order do |order|
      if order.is_stock_checking?
        (order.schecks.empty? or (!order.schecks.empty? and order.get_order_stock_check.is_done?)) and
        user.get_permission(:inventory, :order_stock_checks, :schecks, :check) == 'yes'
      end
    end
    
    # Edit for stock check exist
    can :stock_check_exist, Erp::Orders::Order do |order|
      (!order.schecks.empty? and order.get_order_stock_check.is_draft?) and
      user.get_permission(:inventory, :order_stock_checks, :schecks, :check) == 'yes'
    end
    
    # Set status like done for stock check
    can :confirm_stock_check, Erp::Orders::Order do |order|
      (!order.schecks.empty? and order.get_order_stock_check.is_draft?) and
      user.get_permission(:inventory, :order_stock_checks, :schecks, :approve_order) == 'yes'
    end
  end
end