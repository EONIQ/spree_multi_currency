Spree::Core::Engine.add_routes do
  post '/currency/set', to: 'currency#set', defaults: { format: :json }, as: :set_currency
  post '/currency/get', to: 'currency#get', defaults: { format: :json }, as: :get_currency

  namespace :admin do
    resources :products do
      resources :prices, only: [:index, :create]
    end
  end
end
