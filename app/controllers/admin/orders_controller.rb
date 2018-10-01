class Admin::OrdersController < Admin::ApplicationController
  def index
    paginated_orders
  end

  def show
    order
  end

  def accept
    order.to_published
    redirect_to admin_orders_path
  end

  def reject
    order.to_rejected(params[:reason])
    redirect_to admin_orders_path
  end

  private

  def paginated_orders
    @paginated_orders ||= orders.page(params[:page])
  end

  def order
    @order ||= orders.find(params[:id])
  end

  def orders
    @orders ||= Order.moderation
  end
end
