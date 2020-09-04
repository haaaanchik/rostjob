class Admin::ProductionSitesController < Admin::ApplicationController
  before_action :set_authorize
  before_action :set_production_site, except: :index

  def index
    @q = AnalyticsProductionSitesSpecification.to_scope.ransack(params[:q])
    @platforms = @q.result.includes(:orders).page(params[:page])
  end

  def edit; end

  def update
    if @platform.update(production_sites_params)
      redirect_to admin_production_sites_path
    else
      render json: {  validate: true,
                      data: errors_data(@platform) },
                      status: 422
    end
  end

  def destroy
    redirect_to admin_production_sites_path if @platform.destroy
  end

  private

  def set_production_site
    @platform = ProductionSite.find(params[:id])
  end

  def production_sites_params
    params.require(:production_site).permit(:title, :info, :phones)
  end

  def set_authorize
    authorize [:admin, :production_site]
  end
end