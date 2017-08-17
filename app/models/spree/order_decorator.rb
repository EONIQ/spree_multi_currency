Spree::Order.class_eval do 
  after_update :update_shipping_rate_currencies, if: :currency_changed?
  after_update :update_promotion_currencies, if: :currency_changed?
  after_update :refresh_totals, if: :currency_changed?

  def currency
    self[:currency] || self.currency_default
  end

  def self.currency_default
  	Spree::Store.current_store ? Spree::Store.current_store.default_currency : nil || Spree::Config[:currency]
  end

  def set_currency
    self.currency = currency_default if self[:currency].nil?
  end

  def currency_default
    self.class.currency_default
  end

  def update_shipping_rate_currencies
    updater.update_shipments
  end

  def update_promotion_currencies
    adjustments.collect(&:update!)
  end

  def refresh_totals
    updater.update_totals
    updater.update_order_total
    persist_totals
  end
end