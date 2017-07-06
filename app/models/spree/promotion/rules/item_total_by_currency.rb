# A rule to apply to an order greater than (or greater than or equal to)
# a specific amount
module Spree
  class Promotion
    module Rules
      class ItemTotalByCurrency < PromotionRule
        preference :amount_min_by_currency, :text, default: "[{\"amount\": 10, \"currency\": \"#{Spree::Config[:currency]}\"}]"
        preference :operator_min, :string, default: 'na'
        preference :amount_max_by_currency, :text, default: "[{\"amount\": 10, \"currency\": \"#{Spree::Config[:currency]}\"}]"
        preference :operator_max, :string, default: 'na'

        OPERATORS_MIN = ['gt', 'gte', 'na']
        OPERATORS_MAX = ['lt','lte', 'na']

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, options = {})
          item_total = order.item_total

          case preferred_operator_min
          when 'gt'
            lower_limit_condition = item_total.send(:>, BigDecimal.new(amount_min_in(order.currency).to_s))
          when 'gte'
            lower_limit_condition = item_total.send(:>=, BigDecimal.new(amount_min_in(order.currency).to_s))
          when 'na'
            lower_limit_condition = true
          end

          case preferred_operator_max
          when 'lt'
            upper_limit_condition = item_total.send(:<, BigDecimal.new(amount_max_in(order.currency).to_s))
          when 'lte'
            upper_limit_condition = item_total.send(:<=, BigDecimal.new(amount_max_in(order.currency).to_s))
          when 'na'
            upper_limit_condition = true
          end

          eligibility_errors.add(:base, ineligible_message_max(order.currency)) unless upper_limit_condition
          eligibility_errors.add(:base, ineligible_message_min(order.currency)) unless lower_limit_condition

          eligibility_errors.empty?
        end

        private
        def amount_min_in currency
          JSON.parse(preferred_amount_min_by_currency).find { |a| a['currency'].upcase == currency.upcase }['amount']
        end

        def amount_max_in currency
          JSON.parse(preferred_amount_max_by_currency).find { |a| a['currency'].upcase == currency.upcase }['amount']
        end

        def formatted_amount_min currency
          Spree::Money.new(amount_min_in(currency), {currency: currency}).to_s
        end

        def formatted_amount_max currency
          Spree::Money.new(amount_max_in(currency), {currency: currency}).to_s
        end

        def ineligible_message_max currency
          if preferred_operator_max == 'gte'
            eligibility_error_message(:item_total_more_than_or_equal, amount: formatted_amount_max(currency))
          else
            eligibility_error_message(:item_total_more_than, amount: formatted_amount_max(currency))
          end
        end

        def ineligible_message_min currency
          if preferred_operator_min == 'gte'
            eligibility_error_message(:item_total_less_than, amount: formatted_amount_min(currency))
          else
            eligibility_error_message(:item_total_less_than_or_equal, amount: formatted_amount_min(currency))
          end
        end

      end
    end
  end
end
