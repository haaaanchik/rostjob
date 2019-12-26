class Profile::ProductionSites::OrderTemplatesController < Profile::ProductionSites::ApplicationController
  before_action :set_order_template, except: %i[index new create]
  before_action :set_position, only: %i[create update]

  def index
    order_templates
    @active_item = :order_templates
  end

  def show; end

  def new
    @order_template = OrderTemplate.new(production_site: production_site)
  end

  def description_info; end

  def additional_info; end

  def edit; end

  def create
    result = Cmd::OrderTemplate::Create.call(profile: current_profile, params: order_template_params,
                                             position: @position, production_site: production_site)
    if result.success?
      redirect_to description_info_profile_production_site_order_template_path(production_site, result.order_template)
    else
      render json: { validate: true, data: errors_data(result.order_template) }, status: 422
    end
  end

  def update
    @order_template.template_creation_step = params[:template_creation_step].to_i
    result = Cmd::OrderTemplate::Update.call(order_template: @order_template, params: order_template_params,
                                             position: @position )
    if result.success?
      params[:commit].nil? ? publish_order(result.order_template, result.order_template.number_of_employees.to_s) :
                             redirect_to_after_update(result.order_template)
    else
      render json: { validate: true, data: errors_data(result.order_template) }, status: 422
    end
  end

  def destroy
    @order_template.destroy
    redirect_to profile_production_site_order_templates_path(production_site)
  end

  def copy
    result = Cmd::OrderTemplate::Copy.call(order_template: @order_template)
    redirect_to profile_production_site_order_templates_path(production_site) if result.success?
  end

  def create_order
    publish_order(@order_template, create_order_params[:number_of_employees])
  end

  def move
    result = Cmd::OrderTemplate::Move.call(order_template: @order_template,
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

  def set_position
    @position = Position.find_by(id: order_template_params[:position_id])
  end

  def set_order_template
    production_site
    @order_template = OrderTemplate.find(params[:id])
  end

  def order_template_params
    params.require(:order_template).permit(:name, :title, :city, :salary, :position_id, :contractor_price,
                                           :skill, :document, contact_person: {}, other_info: {})
  end

  def publish_order(o_template, number_of_employees)
    result = Cmd::OrderTemplate::CreateOrder.call(order_template: o_template, number_of_employees: number_of_employees)

    if result.success?
      redirect_to pre_publish_profile_production_site_order_path(production_site, result.order)
    else
      redirect_to edit_profile_production_site_order_path(production_site, result.order)
    end
  end

  def redirect_to_after_update(order_template)
    case @order_template.template_creation_step.to_i
    when 1
      redirect_to description_info_profile_production_site_order_template_path(production_site, order_template)
    when 2
      redirect_to additional_info_profile_production_site_order_template_path(production_site, order_template)
    else
      redirect_to profile_production_site_orders_path(production_site, order_template)
    end
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
