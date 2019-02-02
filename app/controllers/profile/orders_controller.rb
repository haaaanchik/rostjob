class Profile::OrdersController < ApplicationController
  def index
    orders
  end

  def show
    order
    contractors

    order.proposal_employees.map(&:mark_as_read)
  end

  def new
    @order = Order.new(description: description)
  end

  def edit
    order
  end

  def create
    result = Cmd::Order::Create.call(profile: current_profile, params: params_with_price, position: position)
    if result.success?
      redirect_to profile_orders_path
    else
      render json: { validate: true, data: errors_data(result.order) }
    end
  end

  def update
    result = Cmd::Order::Update.call(order: order, params: params_with_price)
    if result.success?
      redirect_to profile_order_path(result.order)
    else
      render json: { validate: true, data: errors_data(result.order) }
    end
  end

  def destroy
    order.destroy
    redirect_to profile_orders_path
  end

  def create_pre_publish
    result = Cmd::Order::Create.call(profile: current_profile, params: params_with_price,
                                     position: position)
    if result.success?
      redirect_to pre_publish_profile_order_path(result.order)
    else
      render json: { validate: true, data: errors_data(result.order) }
    end
  end

  def update_pre_publish
    result = Cmd::Order::Update.call(order: order, params: params_with_price)
    if result.success?
      redirect_to pre_publish_profile_order_path(result.order)
    else
      render json: { validate: true, data: errors_data(context.order) }
    end
  end

  def pre_publish
    Cmd::Order::WaitForPayment.call(order: order)
    render 'pre_publish', locals: { order: order, balance: order.profile.balance.amount }
  end

  def publish
    result = Cmd::Order::ToModeration.call(order: order)
    if result.success?
      redirect_to profile_orders_path
    else
      redirect_to pre_publish_profile_order_path(result.order)
      # redirect_to profile_invoices_path
    end
  end

  def hide
    order.to_hidden
    redirect_to profile_orders_path
  end

  def complete
    Cmd::Order::Complete.call(order: order)
    redirect_to profile_orders_path
  end

  def cancel
    order.to_draft
    redirect_to profile_orders_path
  end

  def add_position
    position_params = params.require(:position).permit(:title, :duties, :price_group_id)
    @position = Position.create(position_params)
  end

  private

  def contractors
    @contractors ||= order.profiles.map do |profile|
      profile.sent_proposal_employees = profile.sent_proposal_employees_by_order(order).inbox
      profile
    end
  end

  def params_with_price
    if position
      order_params[:base_customer_price] = position&.price_group&.customer_price
      order_params[:base_contractor_price] = position&.price_group&.contractor_price
      order_params[:title] = position&.title

      if order_params[:contractor_price].to_i == position.price_group.contractor_price
        order_params[:customer_price] = position&.price_group&.customer_price
        order_params[:contractor_price] = position&.price_group&.contractor_price
        order_params[:customer_total] = position.price_group.customer_price * order_params[:number_of_employees].to_i
        order_params[:contractor_total] = position.price_group.contractor_price * order_params[:number_of_employees].to_i
      else
        factor = order_params[:contractor_price].to_d / position.price_group.contractor_price
        new_customer_price = (position.price_group.customer_price * factor).ceil

        order_params[:customer_price] = new_customer_price
        order_params[:customer_total] = order_params[:customer_price].to_i * order_params[:number_of_employees].to_i
        order_params[:contractor_total] = order_params[:contractor_price].to_i * order_params[:number_of_employees].to_i
      end
    end
    order_params
  end

  def position
    @position ||= Position.find_by(id: order_params[:position_id])
  end

  def order_params
    @order_params ||= params.require(:order)
                            .permit(:title, :specialization, :city, :salary_from, :position_id,
                                    :salary_to, :description, :payment_type, :contractor_price,
                                    :number_of_recruiters, :enterpreneurs_only,
                                    :skill, :accepted, :district, :experience,
                                    :visibility, :state, :number_of_employees,
                                    :schedule, :work_period, other_info: {})
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
    nil
  end
end
