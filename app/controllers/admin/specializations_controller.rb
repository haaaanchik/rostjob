class Admin::SpecializationsController < Admin::ApplicationController
  ALPHABET = 'АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЭЮЯ'.split('').freeze

  def index
    paginated_specializations
  end

  def new
    @specialization = Specialization.new
  end

  def edit
    specialization
  end

  def create
    @specialization = Specialization.create(specialization_params)
    if @specialization.errors.messages.any?
      render json: errors_data(@specialization)
    else
      redirect_to admin_specializations_path
    end
  end

  def update
    specialization.update(specialization_params)
    if specialization.errors.messages.any?
      render json: errors_data(@specialization)
    else
      redirect_to admin_specializations_path
    end
  end

  def destroy
    specialization.destroy
    redirect_to admin_specializations_path
  end

  private

  def specialization_params
    params.require(:specialization).permit(:title)
  end

  def paginated_specializations
    @paginated_specializations ||= specializations.page(params[:page])
  end

  def specialization
    @specialization ||= Specialization.find(params[:id])
  end

  def specializations
    @specializations ||= Specialization.order(title: :asc)
  end

  def letter_is_valid
    params[:letter] && ALPHABET.include?(params[:letter])
  end

  def specializations
    @specializations ||= if letter_is_valid
                           @letter = params[:letter]
                           letter = "#{params[:letter].downcase}%"
                           Specialization.where('lower(title) like ?', letter)
                                         .order(title: :asc)
                         else
                           Specialization.order(title: :asc)
                         end
  end
end
