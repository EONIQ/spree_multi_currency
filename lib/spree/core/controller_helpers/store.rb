module Spree
  module Core
    module ControllerHelpers
      module Store
        def current_currency
          # ensure session currency is supported
          #
          if defined?(session) && session.key?(:currency) && 
            supported_currencies.map(&:iso_code).include?(session[:currency])
            
            session[:currency]
          else
            Spree::Config[:currency]
          end
        end
      end
    end
  end
end
