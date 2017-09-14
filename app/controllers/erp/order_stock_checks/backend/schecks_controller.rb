module Erp
  module OrderStockChecks
    module Backend
      class SchecksController < Erp::Backend::BackendController
        before_action :set_order_stock_check, only: [:show, :edit, :update, :destroy]
    
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
    
        # GET /order_stock_checks/1
        def show
        end
    
        # GET /order_stock_checks/new
        def new
          @scheck = Scheck.new
          
          @order = Erp::Orders::Order.find(params[:order_id])
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
        end
    
        # POST /order_stock_checks
        def create
          @scheck = Scheck.new(scheck_params)

          @scheck.creator = current_user
          
          if @scheck.save
            
            if params.to_unsafe_hash[:act] == 'Lưu tạm'
              @scheck.set_draft
            elsif params.to_unsafe_hash[:act] == 'Hoàn thành'
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
              redirect_to erp_order_stock_checks.edit_backend_scheck_path(@scheck), notice: t('.success')
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
            
            if params.to_unsafe_hash[:act] == 'Lưu tạm'
              @scheck.set_draft
            elsif params.to_unsafe_hash[:act] == 'Hoàn thành'
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
              redirect_to erp_order_stock_checks.edit_backend_scheck_path(@scheck), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # DELETE /order_stock_checks/1
        def destroy
          @scheck.destroy
          
          respond_to do |format|
            format.html { redirect_to erp_order_stock_checks.backend_schecks_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_order_stock_check
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
