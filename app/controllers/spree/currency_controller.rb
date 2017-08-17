module Spree
  class CurrencyController < StoreController
    def get
      @currencies = supported_currencies

      respond_to do |format|
        format.json { render json: @currencies }
        format.html do
          redirect_back_or_default(root_path)
        end
      end
    end

    def set
      @currency = supported_currencies.find { |currency| currency.iso_code == params[:currency] }
      # Make sure that we update the current order, so the currency change is reflected.
      Spree::Order.transaction do 
        current_order.update_attributes!(currency: @currency.iso_code) if current_order
      end
      session[:currency] = params[:currency] if Spree::Config[:allow_currency_change]

      respond_to do |format|
        format.json { render json: !@currency.nil? }
        format.html do
          # We want to go back to where we came from!
          redirect_back_or_default(root_path)
        end
      end
    end
  end
end
