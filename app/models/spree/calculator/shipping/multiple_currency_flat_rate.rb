require_dependency 'spree/shipping_calculator'

module Spree
  module Calculator::Shipping
    class MultipleCurrencyFlatRate < ShippingCalculator
      preference :amount_by_currency, :text, default: "[{\"amount\": 10, \"currency\": \"#{Spree::Config[:currency]}\"}]"

      def self.description
        Spree.t(:flat_rate_by_multiple_currency)
      end

      def compute_package(package=nil)
        amount = 0
        JSON.parse(preferred_amount_by_currency).each do |amount_by_currency|
          if package && amount_by_currency['currency'].upcase == package.currency.upcase
            amount = amount_by_currency['amount']
          end
        end
        
        amount
      end
    end
  end
end
