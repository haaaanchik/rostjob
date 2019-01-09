class Admin::CitiesController < Admin::ApplicationController
  def index
    paginated_cities
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
      render json: {validate: true, data: errors_data(@city)}
    else
      redirect_to admin_cities_path
    end
  end

  def update
    city.update(city_params)
    if city.errors.messages.any?
      render json: {validate: true, data: errors_data(@city)}
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

  def paginated_cities
    @paginated_cities ||= cities.page(params[:page])
  end

  def city
    @city ||= cities.find(params[:id])
  end

  def term_is_valid
    params[:term] && !params[:term].empty?
  end

  def cities
    @cities ||= if term_is_valid
                  term = "#{params[:term].downcase}%"
                  City.where('lower(title) like ?', term).order(title: :asc)
                else
                  City.order(title: :asc)
                end
  end
end
