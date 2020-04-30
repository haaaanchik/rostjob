class Admin::OrdersController < Admin::ApplicationController
  def index
    paginated_orders
  end

  def show
    order
  end

  def accept
    Cmd::Order::ToPublished.call(order: order)
    redirect_to admin_orders_path
  end

  def reject
    order.to_rejected(params[:reason])
    redirect_to admin_orders_path
  end

  def update
    result = Cmd::Order::Update.call(order: order, params: order_params)
    if result.success?
      redirect_to admin_order_path(order)
    else
      render json: { validate: true, data: errors_data(result.order) }, status: 422
    end
  end

  private

  def paginated_orders
    @paginated_orders ||= orders.page(params[:page])
  end

  def order
    @order ||= Order.find(params[:id])
  end

  def order_params
    params.require(:order)
        .permit(:email, :phone_number, :skill, :name, :city, :salary,
                contact_person: {}, other_info: {})
  end

  def orders
    @orders ||= Order.moderation
  end
end
