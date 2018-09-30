class Admin::OrdersController < Admin::ApplicationController
  def index
    paginated_orders
  end

  def show
    order
  end

  def accept
    order.publish!
    order.comments.create(text: 'Заявка допущена к публикации')
    redirect_to admin_orders_path
  end

  def reject
    order.reject!
    order.comments.create(text: params[:reason])
    amount = order.total
    balance = order.profile.balance
    balance.deposit(amount, "Возврат оплаты за публикацию заявки №#{order.id}. Причина: не прошла модерацию.")
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
