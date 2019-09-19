class Profile::ProductionSites::OrderTemplatesController < Profile::ProductionSites::ApplicationController
  def index
    order_templates
    @active_item = :order_templates
  end

  def show
    order_template
  end

  def new
    @order_template = OrderTemplate.new(production_site: production_site)
  end

  def edit
    order_template
  end

  def create
    result = Cmd::OrderTemplate::Create.call(profile: current_profile, params: params_with_price,
                                             position: position, production_site: production_site)
    if result.success?
      redirect_to profile_production_site_order_templates_path(production_site)
    else
      render json: { validate: true, data: errors_data(result.order_template) }, status: 422
    end
  end

  def update
    result = Cmd::OrderTemplate::Update.call(order_template: order_template, params: params_with_price)
    if result.success?
      redirect_to profile_production_site_order_templates_path(production_site)
    else
      render json: { validate: true, data: errors_data(result.order_template) }, status: 422
    end
  end

  def destroy
    order_template.destroy
    redirect_to profile_production_site_order_templates_path(production_site)
  end

  def copy
    result = Cmd::OrderTemplate::Copy.call(order_template: order_template)
    redirect_to profile_production_site_order_templates_path(production_site) if result.success?
  end

  def create_order
    number_of_employees = create_order_params[:number_of_employees]
    result = Cmd::OrderTemplate::CreateOrder.call(order_template: order_template, number_of_employees: number_of_employees)

    if result.success?
      redirect_to pre_publish_profile_production_site_order_path(production_site, result.order)
    else
      redirect_to edit_profile_production_site_order_path(production_site, result.order)
    end
  end

  def move
    result = Cmd::OrderTemplate::Move.call(order_template: order_template,
                                           dst_production_site_id: dst_production_site_id)

    if result.success?
      redirect_to profile_production_site_order_templates_path(production_site)
    else
      render json: { validate: true, data: errors_data(result.order_template) }, status: 422
    end
  end

  private

  def dst_production_site_id
    move_order_template_params[:production_site_id]
  end

  def move_order_template_params
    params.require(:order_template).permit(:production_site_id)
  end

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
                                     .permit(:name, :title, :specialization, :city, :salary, :for_cis,
                                             :position_id, :description, :state, :advertising, :adv_text,
                                             :contractor_price, :skill, :accepted, :district,
                                             :experience, :visibility, :number_of_employees, :document,
                                             :schedule, :work_period, :place_of_work, contact_person: {}, other_info: {})
  end

  def order_template
    @order_template ||= order_templates.find(params[:id])
  end

  def order_templates
    @q = if production_site
           current_profile.production_sites.find(production_site.id)
                          .order_templates.order(id: :desc).ransack(params[:q])
         else
           current_profile.order_templates.order(id: :desc).ransack(params[:q])
         end
    @order_templates ||= @q.result
  end
end
