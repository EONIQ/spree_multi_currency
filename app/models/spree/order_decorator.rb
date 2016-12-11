Spree::Order.class_eval do 
  def currency
    self[:currency] || self.currency_default
  end

  def currency_default
  	Spree::Store.current_store ? Spree::Store.current_store.default_currency : nil || Spree::Config[:currency]
  end
end