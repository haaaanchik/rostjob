class Admin::CitiesController < Admin::ApplicationController
  def index
    cities
  end

  def new
    @city = City.new
  end

  def edit
    city
  end

  def create
    @city = City.create(city_params)
    if @city.errors.messages.any?
      render 'new'
    else
      redirect_to admin_cities_path
    end
  end

  def update
    city.update(city_params)
    if city.errors.messages.any?
      render 'edit'
    else
      redirect_to admin_cities_path
    end
  end

  def destroy
    city.destroy
    redirect_to admin_cities_path
  end

  private

  def city_params
    params.require(:city).permit(:title)
  end

  def city
    @city ||= cities.find(params[:id])
  end

  def cities
    @cities ||= City.order(title: :asc)
  end
end
