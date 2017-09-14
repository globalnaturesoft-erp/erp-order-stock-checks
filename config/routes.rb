Erp::OrderStockChecks::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :backend, module: "backend", path: "backend/order_stock_checks" do
      resources :schecks do
        collection do
          post 'list'
          get 'scheck_details'
        end
      end
      resources :scheck_details do
        collection do
        end
      end
    end
  end
end