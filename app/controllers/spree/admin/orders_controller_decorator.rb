Spree::Admin::OrdersController.class_eval do
  def update_currency
    @order = Spree::Order.friendly.find(params[:id])
    authorize! action, @order

    flash[:success] = Spree.t(:order_updated) if @order.update(params.permit(:currency))
    redirect_to edit_admin_order_url(@order)
  end
end