class Profile::ProductionSitesController < ApplicationController
  def index
    @active_item = :production_sites
    production_sites
  end

  def show
    production_site
  end

  def new
    @production_site = ProductionSite.new
  end

  def edit
    production_site
  end

  def create
    result = production_sites.create(production_site_params)
    if result.persisted?
      redirect_to profile_production_sites_path
    else
      render json: { validate: true, data: errors_data(result) }, status: 422
    end
  end

  def update
    if production_site.update(production_site_params)
      redirect_to profile_production_sites_path
    else
      render json: { validate: true, data: errors_data(production_site) }, status: 422
    end
  end

  private

  def production_site_params
    params.require(:production_site).permit(:title, :image, :city, :info, :phones)
  end

  def production_site
    @production_site ||= production_sites.find(params[:id])
  end

  def production_sites
    @production_sites ||= current_profile.production_sites
  end
end
