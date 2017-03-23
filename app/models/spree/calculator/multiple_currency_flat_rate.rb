require_dependency 'spree/calculator'

module Spree
  class Calculator::MultipleCurrencyFlatRate < Calculator
    preference :amount_by_currency, :text, default: "[{\"amount\": 10, \"currency\": \"#{Spree::Config[:currency]}\"}]"

    def self.description
      Spree.t(:flat_rate_by_multiple_currency)
    end

    def compute_package(object=nil)
      amount = 0
      JSON.parse(preferred_amount_by_currency).each do |amount_by_currency|
        if object && amount_by_currency['currency'].upcase == object.currency.upcase
          amount = amount_by_currency['amount']
        end
      end
      
      amount
    end

    def compute_order(order=nil)
      compute_package(order)
    end
  end
end
