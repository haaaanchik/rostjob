class Profile::ProductionSites::OrdersController < Profile::ProductionSites::ApplicationController
  expose :order_templates,    -> { production_site.order_templates.order(id: :desc) }
  expose :production_sites,   -> { current_profile.production_sites }
  expose :waiting_pay_orders, -> { fetch_waiting_pay_orders }
  expose :completed_orders,   -> { fetch_completed_orders }
  expose :moderation_orders,  -> { fetch_moderation_orders }
  expose :published_orders,   -> { fetch_published_orders }

  def index
    @state = state
    orders
    orders_kind
    @active_item = case state
                   when nil
                     :my_orders
                   when 'in_progress'
                     :in_progress
                   when 'completed'
                     :completed
                   when 'moderation'
                     :moderation
                   end
  end

  def show
    order
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
      render json: { validate: true, data: errors_data(result.order) }, status: 422
    end
  end

  def update
    result = Cmd::Order::Update.call(order: order, params: params_with_price)
    @order = result.order
    if result.success?
      redirect_to profile_production_site_orders_with_state_path(production_site, :in_progress)
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
      render json: { validate: true, data: errors_data(result.order) }, status: 422
    end
  end

  def update_pre_publish
    result = Cmd::Order::Update.call(order: order, params: params_with_price)
    if result.success?
      redirect_to pre_publish_profile_production_site_order_path(production_site, result.order)
    else
      render json: { validate: true, data: errors_data(context.order) }, status: 422
    end
  end

  def pre_publish
    Cmd::Order::WaitForPayment.call(order: order)
    render 'pre_publish', locals: { order: order.decorate, balance: order.profile.balance.amount }
  end

  def publish
    result = Cmd::Order::ToModeration.call(order: order, params: order_params)
    if result.success?
      SendModerationMailJob.perform_later(order: result.order)
      redirect_to profile_production_site_orders_with_state_path(production_site, :in_progress)
    else
      redirect_to pre_publish_profile_production_site_order_path(production_site, result.order)
    end
  end

  def hide
    order.to_hidden
    redirect_to profile_production_site_orders_with_state_path(production_site, :in_progress)
  end

  def complete
    Cmd::Order::Complete.call(order: order)
    redirect_to profile_production_site_orders_with_state_path(production_site, :in_progress)
  end

  def cancel
    order.to_draft
    redirect_to profile_production_site_orders_with_state_path(production_site, :in_progress)
  end

  def add_position
    position_params = params.require(:position).permit(:title, :duties, :price_group_id)
    @position = Position.create(position_params)
  end

  def move
    result = Cmd::Order::Move.call(order: order,
                                   dst_production_site_id: dst_production_site_id)

    if result.success?
      redirect_to profile_production_site_orders_path(production_site)
    else
      render json: { validate: true, data: errors_data(result.order) }, status: 422
    end
  end

  def add_additional_employees
    Cmd::Order::AddToNumberOfEmployees.call(order: order)
    redirect_to profile_production_site_order_path(production_site, order)
  end

  private

  def dst_production_site_id
    move_order_params[:production_site_id]
  end

  def move_order_params
    params.require(:order).permit(:production_site_id)
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
                                    :number_of_recruiters, :enterpreneurs_only, :for_cis,
                                    :skill, :accepted, :district, :experience, :advertising,
                                    :visibility, :state, :number_of_employees, :document,
                                    :schedule, :work_period, :place_of_work, :adv_text,
                                    :number_additional_employees, other_info: {}, contact_person: {})
  end

  def balance
    order.profile.balance
  end

  def order
    @order ||= orders.find(params[:id])
  end

  def fetch_waiting_pay_orders
    orders.waiting_for_payment
  end

  def fetch_completed_orders
    orders.completed
  end

  def fetch_moderation_orders
    orders.moderation
  end

  def fetch_published_orders
    orders.published.order(advertising: :desc)
  end

  def orders
    @orders ||= Order.where(profile: current_profile, production_site_id: production_site)
                     .with_pe_counts
                     .order(urgency_level: :desc, created_at: :desc)
                     .includes(profile: :company)
  end

  def local_prefixes
    [controller_path]
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
