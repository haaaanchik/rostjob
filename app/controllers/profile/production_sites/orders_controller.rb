class Profile::ProductionSites::OrdersController < Profile::ProductionSites::ApplicationController
  expose :order_templates,    -> { production_site.order_templates.order(id: :desc) }
  expose :production_sites,   -> { current_profile.production_sites }
  expose :waiting_pay_orders, -> { fetch_waiting_pay_orders }
  expose :completed_orders,   -> { fetch_completed_orders }
  expose :moderation_orders,  -> { fetch_moderation_orders }
  expose :published_orders,   -> { fetch_published_orders }

  def index
    orders
    @active_item = :production_sites
  end

  def show
    order
    order.proposal_employees.map(&:mark_as_read)
    @proposal_employee = ProposalEmployee.find_by(id: params[:proposal_employee_id])
  end

  def update
    order.creation_step = params[:creation_step].to_i
    result = Cmd::Order::Update.call(order: order, params: order_params)
    if result.success?
      redirect_to_after_update(result.order)
    else
      render json: { validate: true, data: errors_data(result.order) }, status: 422
    end
  end

  def update_pre_publish
    result = Cmd::Order::Update.call(order: order, params: order_params)
    if result.success?
      redirect_to pre_publish_profile_production_site_order_path(production_site, result.order)
    else
      render json: { validate: true, data: errors_data(result.order) }, status: 422
    end
  end

  def pre_publish
    Cmd::Order::WaitForPayment.call(order: order)
    render 'pre_publish', locals: { order: order.decorate, balance: order.profile.balance.amount }
  end

  def publish
    result = Cmd::Order::ToModeration.call(order: order, params: order_params)
    if result.success?
      redirect_to profile_production_site_orders_path(production_site, tab_state: 'on_moderation')
    else
      redirect_to pre_publish_profile_production_site_order_path(production_site, result.order)
    end
  end

  def hide
    order.to_hidden
    redirect_to profile_production_site_orders_path(production_site)
  end

  def complete
    Cmd::Order::Complete.call(order: order)
    redirect_to profile_production_site_orders_path(production_site, tab_state: 'finished')
  end

  def cancel
    order.to_draft
    redirect_to profile_production_site_orders_path(production_site)
  end

  # FIXME: refactor this asap
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

  def position
    @position ||= Position.find_by(id: order_params[:position_id])
  end

  def order_params
    @order_params ||= params.require(:order)
                            .permit(:city, :salary, :contractor_price, :skill,
                                    :number_of_employees, :document, :number_additional_employees,
                                    other_info: {}, contact_person: {})
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

  def set_resource
    @model_resource = order.decorate
  end

  def redirect_to_after_update(order)
    case order.creation_step.to_i
    when 2
      redirect_to third_step_profile_production_site_order_path(production_site, order)
    else
      redirect_to profile_production_site_order_path(production_site, order)
    end
  end

  def orders
    @orders ||= Order.where(profile: current_profile, production_site_id: production_site)
                     .with_pe_counts
                     .order(urgency_level: :desc, created_at: :desc)
                     .includes(profile: :company)
  end
end
