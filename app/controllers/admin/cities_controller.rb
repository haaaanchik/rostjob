class Admin::CitiesController < Admin::ApplicationController
  ALPHABET = 'АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЭЮЯ'.split('').freeze

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
      render json: errors_data(@city)
    else
      redirect_to admin_cities_path
    end
  end

  def update
    city.update(city_params)
    if city.errors.messages.any?
      render json: errors_data(@city)
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

  def letter_is_valid
    params[:letter] && ALPHABET.include?(params[:letter])
  end

  def cities
    @cities ||= if letter_is_valid
                  @letter = params[:letter]
                  letter = "#{params[:letter].downcase}%"
                  City.where('lower(title) like ?', letter).order(title: :asc)
                else
                  City.order(title: :asc)
                end
  end
end
