class Profile::OrdersController < ApplicationController
  def index
    orders
  end

  def show
    order
  end

  def new
    @order = Order.new(description: description)
  end

  def edit
    order
  end

  def create
    orders.create!(order_params)
    redirect_to profile_orders_path
  end

  def update
    order.update(order_params)
    redirect_to profile_order_path(order)
  end

  def destroy
    order.destroy
    redirect_to profile_orders_path
  end

  def pre_publish
    render 'pre_publish', locals: { order: order }
  end

  def create_pre_publish
    new_order = orders.create!(order_params)
    render 'pre_publish', locals: { order: new_order }
  end

  def update_pre_publish
    order.update(order_params)
    render 'pre_publish', locals: { order: order }
  end

  def publish
    if balance.withdrawal(order.summ, "Публикация заявки #{order.id}")
      order.to_moderation!
      redirect_to profile_orders_path
    else
      redirect_to profile_balance_path
    end
  end

  def hide
    order.hide!
    redirect_to profile_orders_path
  end

  def complete
    order.complete!
    redirect_to profile_orders_path
  end

  private

  def order_params
    params.require(:order).permit(:title, :specialization, :city, :salary_from,
                                  :salary_to, :description, :commission, :payment_type,
                                  :number_of_recruiters, :enterpreneurs_only,
                                  :requirements_for_recruiters, :stop_list, :accepted,
                                  :visibility, :state, :warranty_period, :number_of_employees)
  end

  def balance
    order.profile.balance
  end

  def order
    @order ||= orders.find(params[:id])
  end

  def orders
    @orders ||= if params[:state] && !params[:state].empty?
                  current_profile.orders.where state: params[:state]
                else
                  current_profile.orders
                end
  end

  def description
    '<p><strong>Требования:</strong></p><p><strong>Условия:</strong></p>'
  end
end
