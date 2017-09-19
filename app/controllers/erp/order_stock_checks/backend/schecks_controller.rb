module Erp
  module OrderStockChecks
    module Backend
      class SchecksController < Erp::Backend::BackendController
        before_action :set_scheck, only: [:edit, :update, :set_done]
    
        # GET /order_stock_checks
        def index
        end
        
        # POST /givens/list
        def list
          @orders = Erp::Orders::Order.stock_check_orders.search(params).paginate(:page => params[:page], :per_page => 10)
          
          render layout: nil
        end
        
        def scheck_details
          @scheck = Erp::OrderStockChecks::Scheck.where(order_id: params[:order_id]).order('created_at desc').first # Get newest stock check
        end
    
        # GET /order_stock_checks/new
        def new
          @order = Erp::Orders::Order.find(params[:order_id])
          authorize! :stock_check, @order
          
          @scheck = Scheck.new
          @scheck.employee = current_user
          @scheck.order = @order
          @order.order_details.each do |ord|
            @scheck.scheck_details.build(
              order_detail_id: ord.id
            )
          end
          
          if request.xhr?
            render '_form', layout: nil, locals: {scheck: @scheck}
          end
        end
    
        # GET /order_stock_checks/1/edit
        def edit
          authorize! :stock_check_exist, @scheck.order
          @order = Erp::Orders::Order.find(@scheck.order_id)
        end
    
        # POST /order_stock_checks
        def create
          @scheck = Scheck.new(scheck_params)

          @scheck.creator = current_user
          
          if @scheck.save
            
            if params.to_unsafe_hash[:act_draft].present?
              @scheck.set_draft
            elsif params.to_unsafe_hash[:act_done].present?
              @scheck.set_done
              @scheck.update_order_status # Cập nhật trạng thái cho đơn hàng đã được kiểm tra
            end
            
            if request.xhr?
              render json: {
                status: 'success',
                text: @scheck.code,
                value: @scheck.id
              }
            else
              redirect_to erp_order_stock_checks.backend_schecks_path, notice: t('.success')
            end
          else
            if request.xhr?
              render '_form', layout: nil, locals: {scheck: @scheck}
            else
              render :new
            end
          end
        end
    
        # PATCH/PUT /order_stock_checks/1
        def update
          if @scheck.update(scheck_params)
            
            if params.to_unsafe_hash[:act_draft].present?
              @scheck.set_draft
            elsif params.to_unsafe_hash[:act_done].present?
              @scheck.set_done
              @scheck.update_order_status # Cập nhật trạng thái cho đơn hàng đã được kiểm tra
            end
            
            if request.xhr?
              render json: {
                status: 'success',
                text: @scheck.code,
                value: @scheck.id
              }
            else
              redirect_to erp_order_stock_checks.backend_schecks_path, notice: t('.success')
            end
          else
            render :edit
          end
        end
        
        # Set DONE /order_stock_checks/set_done?id=1
        def set_done
          authorize! :confirm_stock_check, @scheck.order
          @scheck.set_done
          @scheck.update_order_status

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end
        
        def warehouse_info
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_scheck
            @scheck = Scheck.find(params[:id])
          end
    
          # Only allow a trusted parameter "white list" through.
          def scheck_params
            params.fetch(:scheck, {}).permit(:code, :employee_id, :order_id,
                          :scheck_details_attributes => [ :id, :order_detail_id, :available, {:alternative_items => []}, :note, :_destroy ])
          end
      end
    end
  end
end
