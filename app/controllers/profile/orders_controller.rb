class Profile::OrdersController < ApplicationController
  def index
    orders
  end

  def show
    order
  end

  def new
    @order = Order.new
  end

  def edit
    order
  end

  def create
    orders.create(order_params)
    redirect_to profile_orders_path
  end

  def update
    order.update(order_params)
    redirect_to profile_orders_path
  end

  def destroy
    order.destroy
    redirect_to profile_orders_path
  end

  def publish
    order.publish!
    redirect_to profile_orders_path
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
                                  :visibility, :state, :warranty_period)
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
end
