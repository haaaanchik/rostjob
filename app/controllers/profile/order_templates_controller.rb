class Profile::OrderTemplatesController < ApplicationController
  def index
    # order_templates
    @order_template_search_form = OrderTemplateSearchForm.new(profile: current_profile,
                                                              params: order_template_search_form_params)
    @order_templates = @order_template_search_form.submit
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
      render json: { validate: true, data: errors_data(result.order_template) }
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

  def create_order
    number_of_employees = create_order_params[:number_of_employees].to_i
    profession = Position.find(order_template.position_id)
    customer_total = order_template.customer_price * number_of_employees
    contractor_total = order_template.contractor_price * create_order_params[:number_of_employees].to_i
    attributes = order_template.attributes
    order_attributes = attributes.merge('id' => nil, 'number_of_employees' => number_of_employees,
                                        'customer_total' => customer_total, 'contractor_total' => contractor_total)
                                 .except('name', 'created_at', 'updated_at')
    result = Cmd::Order::Create.call(profile: current_profile, params: order_attributes, position: profession)
    result.order.document = order_template.document
    result.order.save
    if result.success?
      redirect_to pre_publish_profile_order_path(result.order)
    else
      redirect_to edit_profile_order_path(result.order)
    end

  end

  private

  def create_order_params
    params.require(:order_template).permit(:number_of_employees)
  end

  def order_template_search_form_params
    params.permit(order_template_search_form: %i[query])[:order_template_search_form]
  end

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
                                     .permit(:name, :title, :specialization, :city, :salary_from,
                                             :position_id, :salary_to, :description, :state,
                                             :contractor_price, :skill, :accepted, :district,
                                             :experience, :visibility, :number_of_employees, :document,
                                             :schedule, :work_period, :place_of_work, contact_person: {}, other_info: {})
  end

  def order_template
    @order_template ||= order_templates.find(params[:id])
  end

  def order_templates
    @order_templates ||= current_profile.order_templates.order(id: :desc)
  end
end
