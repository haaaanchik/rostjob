class Profile::OrdersController < ApplicationController
  def index
    @state = params[:state]
    orders
    orders_kind
    @active_item = case params[:state]
                   when nil
                     :my_orders
                   when 'in_progress'
                     :in_progress
                   when 'completed'
                     :completed
                   end
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
      redirect_to profile_orders_with_state_path(:in_progress)
    else
      render json: { validate: true, data: errors_data(result.order) }
    end
  end

  def update
    result = Cmd::Order::Update.call(order: order, params: params_with_price)
    @order = result.order
    if result.success?
      redirect_to profile_orders_path
    else
      render 'edit'
    end
  end

  def destroy
    order.destroy
    redirect_to profile_orders_with_state_path(:in_progress)
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
      SendModerationMailJob.perform_later(order: result.order)
      redirect_to profile_orders_with_state_path(:in_progress)
    else
      redirect_to pre_publish_profile_order_path(result.order)
      # redirect_to profile_invoices_path
    end
  end

  def hide
    order.to_hidden
    redirect_to profile_orders_with_state_path(:in_progress)
  end

  def complete
    Cmd::Order::Complete.call(order: order)
    redirect_to profile_orders_with_state_path(:in_progress)
  end

  def cancel
    order.to_draft
    redirect_to profile_orders_with_state_path(:in_progress)
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
                            .permit(:title, :specialization, :city, :salary, :position_id,
                                    :description, :payment_type, :contractor_price,
                                    :number_of_recruiters, :enterpreneurs_only,
                                    :skill, :accepted, :district, :experience,
                                    :visibility, :state, :number_of_employees, :document,
                                    :schedule, :work_period, :place_of_work, other_info: {},
                                    contact_person: {})
  end

  def balance
    order.profile.balance
  end

  def order
    @order ||= orders.find(params[:id])
  end

  def orders
    @q = if params[:state] && !params[:state].empty?
           if params[:state] == 'completed'
             Order.where(profile: current_profile)
                  .with_pe_counts.where(state: not_in_work_states)
                  .order(urgency_level: :desc, created_at: :desc).ransack(params[:q])
           else
             Order.where(profile: current_profile)
                  .with_pe_counts.where.not(state: not_in_work_states)
                  .order(urgency_level: :desc, created_at: :desc).ransack(params[:q])
           end
         else
           Order.where(profile: current_profile)
                .with_pe_counts.order(urgency_level: :desc, created_at: :desc).ransack(params[:q])
         end

    @orders ||= @q.result
  end

  def not_in_work_states
    %w[completed moderation draft]
  end

  def description
    nil
  end

  def state
    params[:state]
  end

  def orders_kind
    @orders_kind = if state.nil?
                     'все ваши заявки'
                   elsif state.include?('in_progress')
                     'ваши заявки, находящиеся в работе.'
                   elsif state.include?('completed')
                     'ваши завершённые заявки'
                   end
  end
end
