Spree::Core::Engine.add_routes do
  post '/currencies', to: 'currency#set', defaults: { format: :json }, as: :set_currency
  get '/currencies', to: 'currency#get', defaults: { format: :json }, as: :get_currency
  
  namespace :admin, path: Spree.admin_path do
    resources :orders do
      member do
        post '/update_currency', to: 'orders#update_currency'
      end
    end
    resources :products do
      resources :prices, only: [:index, :create]
    end
  end
end