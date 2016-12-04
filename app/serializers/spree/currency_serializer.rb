module Spree
  class CurrencySerializer < ApplicationSerializer
    attributes :id, :iso_code, :alternate_symbol, :html_entity

    def alternate_symbol
      alternate_symbols.first if alternate_symbols && !alternate_symbols.empty?
    end
  end
end
