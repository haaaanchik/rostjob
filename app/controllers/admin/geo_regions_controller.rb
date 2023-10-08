# frozen_string_literal: true

class Admin::GeoRegionsController < Admin::ApplicationController

  before_action :set_region, except: %i[index new create]


  def index
    paginated_region
  end

  def new
    @region = Geo::Region.new
  end

  def create
    @region = Geo::Region.create(region_params)
    if @region.save
      redirect_to admin_geo_regions_path
    else
      render json: { validate: true, data: errors_data(@region) }, status: 422
    end
  end

  def edit; end

  def update
    @region.update(region_params)
    if @region.save
      redirect_to admin_geo_regions_path
    else
      render json: { validate: true, data: errors_data(@region) }, status: 422
    end
  end

  def destroy
    @region.destroy

    redirect_to admin_geo_regions_path
  end

  private

  def region_params
    params.require(:geo_regions).permit(:name, :country_id)
  end

  def set_region
    Geo::Region.find(params[:id])
  end

  def paginated_region
    @paginated_region ||= regions.page(params[:page])
  end

  def regions
    @regions ||= if term_is_valid
                  term = "#{params[:term].downcase.split(',')[0]}%"
                  Geo::Region.where('lower(name) like ?', term).order(name: :asc)
                else
                  Geo::Region.order(name: :asc)
                end
  end

  def term_is_valid
    params[:term] && !params[:term].empty?
  end
end
