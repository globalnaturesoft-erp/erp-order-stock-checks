module Erp::OrderStockChecks
  class Scheck < ApplicationRecord
    belongs_to :creator, class_name: "Erp::User"
    belongs_to :order, class_name: "Erp::Orders::Order", foreign_key: :order_id
    belongs_to :employee, class_name: "Erp::User", foreign_key: :employee_id
    has_many :scheck_details, dependent: :destroy
    accepts_nested_attributes_for :scheck_details, :reject_if => lambda { |a| a[:order_detail_id].blank? }, :allow_destroy => true
    
    validates :code, uniqueness: true
    validates :order_id, presence: true
    
    after_save :generate_code
    
    # class const
    STATUS_DRAFT = 'draft'
    STATUS_DONE = 'done'
    
    # todo value for input submit
    BUTTON_VALUE_DRAFT = 'Lưu tạm'
    BUTTON_VALUE_DONE = 'Hoàn thành'
    
    def employee_name
      employee.present? ? employee.name : ''
    end
    
    # SET status for stock check
		def set_draft
			update_columns(status: Erp::OrderStockChecks::Scheck::STATUS_DRAFT)
		end
		
		def set_done
			update_columns(status: Erp::OrderStockChecks::Scheck::STATUS_DONE)
		end
		
		# check if stock check is draft
		def is_draft?
			return self.status == Erp::OrderStockChecks::Scheck::STATUS_DRAFT
		end
		
		# check if stock check is done
		def is_done?
			return self.status == Erp::OrderStockChecks::Scheck::STATUS_DONE
		end
		
		# Kiểm tra kho có sẵn hàng để bán hay không
		def check_all_available?
      scheck_details.each do |scheck_detail|
        return false if !scheck_detail.available?
      end
      return true
    end
		
		# Cập nhật trạng thái đơn hàng khi phiếu kiểm kho được xác nhận
		def update_order_status
      if self.is_done?
        order.set_stock_checked if !self.check_all_available?
        order.set_stock_approved if self.check_all_available?
      end
    end
    
    # Generate code
    def generate_code
			if !code.present?
				update_columns(code: 'SC' + id.to_s.rjust(3, '0'))
			end
		end
  end
end
