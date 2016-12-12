Spree::LineItem.class_eval do 
  def update_price
    # TODO: Calculate VAT using currency. Original code will change the price into 
    # another currency without changing the currency of the line item
    self.price = variant.price_in(self.currency).amount
  end
end