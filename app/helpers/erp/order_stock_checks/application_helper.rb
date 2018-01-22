module Erp
  module OrderStockChecks
    module ApplicationHelper
      # Order stock check dropdown actions
      def order_stock_check_dropdown_actions(order)
        actions = []
        actions << {
          text: '<i class="fa fa-edit"></i> '+t('.start_check'),
          url: erp_order_stock_checks.new_backend_scheck_path(order_id: order.id)
        } if can? :stock_check, order
        actions << {
          text: '<i class="fa fa-edit"></i> '+t('.continue_check'),
          url: erp_order_stock_checks.edit_backend_scheck_path(order.schecks.last)
        } if can? :stock_check_exist, order
        actions << {
          text: '<i class="fa fa-check"></i> '+t('.achieve'),
          url: erp_order_stock_checks.set_done_backend_schecks_path(id: order.schecks.last),
          data_method: 'PUT',
          class: 'ajax-link',
          data_confirm: t('.achieve_confirm')
        } if can? :confirm_stock_check, order

        erp_datalist_row_actions(
          actions
        )
      end
    end
  end
end
