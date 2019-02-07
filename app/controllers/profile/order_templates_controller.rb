class Profile::OrderTemplatesController < ApplicationController
  def index
    order_templates
  end

  def show
    order_template
  end

  def new
    @order_template = OrderTemplate.new
  end

  def edit
    order_template
  end

  def create
    result = Cmd::OrderTemplate::Create.call(profile: current_profile, params: params_with_price, position: position)
    if result.success?
      redirect_to profile_order_templates_path
    else
      render json: { validate: true, data: errors_data(result.order_teplate) }
    end
  end

  def update
    result = Cmd::OrderTemplate::Update.call(order_template: order_template, params: params_with_price)
    if result.success?
      redirect_to profile_order_templates_path
    else
      render json: { validate: true, data: errors_data(result.order_template) }
    end
  end

  def destroy
    order_template.destroy
    redirect_to profile_order_templates_path
  end

  def copy
    result = Cmd::OrderTemplate::Copy.call(order_template: order_template)
    redirect_to profile_order_templates_path result.success?
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

  def params_with_price
    if position
      order_template_params[:base_customer_price] = position&.price_group&.customer_price
      order_template_params[:base_contractor_price] = position&.price_group&.contractor_price
      order_template_params[:title] = position&.title

      if order_template_params[:contractor_price].to_i == position.price_group.contractor_price
        order_template_params[:customer_price] = position&.price_group&.customer_price
        order_template_params[:contractor_price] = position&.price_group&.contractor_price
        order_template_params[:customer_total] = position.price_group.customer_price * order_template_params[:number_of_employees].to_i
        order_template_params[:contractor_total] = position.price_group.contractor_price * order_template_params[:number_of_employees].to_i
      else
        factor = order_template_params[:contractor_price].to_d / position.price_group.contractor_price
        new_customer_price = (position.price_group.customer_price * factor).ceil

        order_template_params[:customer_price] = new_customer_price
        order_template_params[:customer_total] = order_template_params[:customer_price].to_i * order_template_params[:number_of_employees].to_i
        order_template_params[:contractor_total] = order_template_params[:contractor_price].to_i * order_template_params[:number_of_employees].to_i
      end
    end
    order_template_params
  end

  def position
    @position ||= Position.find_by(id: order_template_params[:position_id])
  end

  def order_template_params
    @order_template_params ||= params.require(:order_template)
                                     .permit(:name, :title, :specialization, :city, :salary_from, :position_id,
                                             :salary_to, :description, :contractor_price,
                                             :skill, :accepted, :district, :experience,
                                             :visibility, :state, :number_of_employees,
                                             :schedule, :work_period, other_info: {})
  end

  def order_template
    @order_template ||= order_templates.find(params[:id])
  end

  def order_templates
    @order_templates ||= current_profile.order_templates.order(id: :desc)
  end
end
