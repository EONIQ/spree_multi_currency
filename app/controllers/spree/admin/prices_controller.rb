module Spree
  module Admin
    class PricesController < ResourceController
      belongs_to 'spree/product', find_by: :slug

      def create
        params.require(:vp).permit!
        params[:vp].each do |variant_id, prices|
          variant = Spree::Variant.find(variant_id)
          next unless variant

          # Fix prices downcased key. It's upcase in view but downcased after using params. Need to figure out why later
          prices.keys.each { |k| prices[k.upcase] = prices[k]; prices.delete(k) }
          supported_currencies.each do |currency|
            price = variant.price_in(currency.iso_code)
            price.price = (prices[currency.iso_code].blank? ? nil : prices[currency.iso_code])
            price.save! if price.new_record? && price.price || !price.new_record? && price.changed?
          end
        end
        flash[:success] = Spree.t('notice_messages.prices_saved')
        redirect_to admin_product_path(parent)
      end
    end
  end
end
