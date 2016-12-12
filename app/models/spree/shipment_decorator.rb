Spree::Shipment.class_eval do
  def currency
    order ? order.currency : (Spree::Store.current_store ? Spree::Store.current_store.default_currency : nil || Spree::Config[:currency])
  end
end