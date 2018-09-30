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
    @order = orders.create(params_with_price)
    @order.errors.add(:position_search, 'Выберите профессию') unless position
    if @order.errors.messages.any?
      render json: errors_data(@order)
    else
      redirect_to profile_orders_path
    end
  end

  def update
    order.update(params_with_price)
    if @order.errors.messages.any?
      render json: errors_data(order)
    else
      redirect_to profile_order_path(order)
    end
  end

  def destroy
    order.destroy
    redirect_to profile_orders_path
  end

  def pre_publish
    render 'pre_publish', locals: { order: order, balance: order.profile.balance.amount }
  end

  def create_pre_publish
    @order = orders.create(params_with_price)
    @order.errors.add(:position_search, 'Выберите профессию') unless position
    if @order.errors.messages.any?
      render json: errors_data(order)
    else
      @order.wait_for_payment!
      redirect_to pre_publish_profile_order_path(@order)
    end
  end

  def update_pre_publish
    order.update(params_with_price)
    if order.errors.messages.any?
      render json: errors_data(order)
    else
      redirect_to pre_publish_profile_order_path(@order)
    end
  end

  def publish
    if balance.withdrawal(order.total, "Публикация заявки #{order.id}")
      order.pay!
      order.to_moderation!
      redirect_to profile_orders_path
    else
      redirect_to profile_invoices_path
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

  def cancel
    order.cancel! if order.may_cancel?
    redirect_to profile_orders_path
  end

  private

  def params_with_price
    order_params[:title] = position&.title
    order_params[:customer_price] = position&.price_group&.customer_price
    order_params[:contractor_price] = position&.price_group&.contractor_price
    order_params[:total] = position.price_group.customer_price * order_params[:number_of_employees].to_i if position
    order_params
  end

  def position
    @position ||= Position.find_by(id: order_params[:position_id])
  end

  def order_params
    @order_params ||= params.require(:order)
                            .permit(:title, :specialization, :city, :salary_from, :position_id,
                                    :salary_to, :description, :payment_type,
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
