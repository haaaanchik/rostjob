class Profile::ProductionSites::OrderTemplatesController < Profile::ProductionSites::ApplicationController
  before_action :set_authorize, except: %i[index]
  before_action :set_order_template, except: %i[index new create destroy_array copy]
  before_action :set_position, only: %i[create update]

  def index
    order_templates
    @active_item = :order_templates
  end

  def new
    @order_template = OrderTemplate.new(production_site: production_site)
  end

  def create
    result = Cmd::OrderTemplate::Create.call(profile: current_profile, params: order_template_params,
                                             position: @position, production_site: production_site,
                                             only_base: true)
    if result.success?
      redirect_to second_step_profile_production_site_order_template_path(production_site, result.order_template)
    else
      render json: { validate: true, data: errors_data(result.order_template) }, status: 422
    end
  end

  def update
    @order_template.creation_step = params[:creation_step].to_i
    result = Cmd::OrderTemplate::Update.call(order_template: @order_template, params: order_template_params,
                                             position: @position)
    if result.success?
      params[:commit].nil? ? publish_order(result.order_template) :
                             redirect_to_after_update(result.order_template)
    else
      render json: { validate: true, data: errors_data(result.order_template) }, status: 422
    end
  end

  def save_name
    if @order_template.update_attribute(:name, params[:name])
      render json: { order_template_id: @order_template.id }, status: 200
    else
      render json: { message: 'не удалось сохранить навзание шаблона' }, status: 422
    end
  end

  def destroy
    @order_template.destroy
    redirect_to profile_production_site_orders_path(@production_site, tab_state: 'templates')
  end

  def destroy_array
    if current_profile.order_templates.where(id: params[:order_ids]).destroy_all
      render json: :no_content, status: :accepted
    else
      render json: :no_content, status: 422
    end
  end

  def copy
    current_profile.order_templates.where(id: params[:order_ids]).each.each do |order_template|
      Cmd::OrderTemplate::Copy.call(order_template: order_template)
    end

    render json: :no_content, status: 201
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

  def set_position
    @position = Position.find_by(id: order_template_params[:position_id])
  end

  def set_order_template
    production_site
    @order_template = OrderTemplate.find(params[:id])
  end

  def order_template_params
    params.require(:order_template).permit(:name, :city, :salary, :position_id, :contractor_price,
                                           :number_of_employees, :skill, :document, :template_saved,
                                           contact_person: {}, other_info: {})
  end

  def publish_order(o_template)
    result = Cmd::OrderTemplate::CreateOrder.call(order_template: o_template)

    if result.success?
      redirect_to pre_publish_profile_production_site_order_path(production_site, result.order)
    else
      redirect_to edit_profile_production_site_order_path(production_site, result.order)
    end
  end

  def redirect_to_after_update(order_template)
    case @order_template.creation_step.to_i
    when 1
      redirect_to second_step_profile_production_site_order_template_path(production_site, order_template)
    when 2
      redirect_to third_step_profile_production_site_order_template_path(production_site, order_template)
    else
      redirect_to profile_production_site_orders_path(production_site, order_template)
    end
  end

  def set_resource
    @model_resource = set_order_template.decorate
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

  def set_authorize
    authorize [:profile, :order_template]
  end
end
