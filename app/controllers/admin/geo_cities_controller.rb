# frozen_string_literal: true

class Admin::GeoCitiesController < Admin::ApplicationController

  before_action :set_city, except: %i[index new create]


  def index
    paginated_city
  end

  def new
    @city = Geo::City.new
  end

  def create
    @city = Geo::City.create(city_params)
    if @city.save
      redirect_to admin_geo_cities_path
    else
      render json: { validate: true, data: errors_data(@city) }, status: 422
    end
  end

  def edit; end

  def update
    @city.update(city_params)
    if @city.save
      redirect_to admin_geo_cities_path
    else
      render json: { validate: true, data: errors_data(@city) }, status: 422
    end
  end

  def destroy
    @city.destroy

    redirect_to admin_geo_cities_path
  end

  private

  def city_params
    params.require(:geo_city).permit(:name, :synonym, :fias_code, :lat, :long, :region_id)
  end

  def set_city
    Geo::City.find(params[:id])
  end

  def paginated_city
    @paginated_city ||= cities.page(params[:page])
  end

  def cities
    @cities ||= if term_is_valid
                  term = "#{params[:term].downcase.split(',')[0]}%"
                  Geo::City.where('lower(name) like ?', term).order(name: :asc)
                else
                  Geo::City.order(name: :asc)
                end
  end

  def term_is_valid
    params[:term] && !params[:term].empty?
  end
end
