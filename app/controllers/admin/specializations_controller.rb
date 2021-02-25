class Admin::SpecializationsController < Admin::ApplicationController
  before_action :set_authorize

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
      render json: { validate: true, data: errors_data(@specialization) }, status: 422
    else
      redirect_to admin_specializations_path
    end
  end

  def update
    specialization.update(specialization_params)
    if specialization.errors.messages.any?
      render json: { validate: true, data: errors_data(@specialization) }, status: 422
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
    params.require(:specialization).permit(:title, :image, position_ids: [])
  end

  def paginated_specializations
    @paginated_specializations ||= specializations.page(params[:page])
  end

  def specialization
    @specialization ||= Specialization.find(params[:id])
  end

  def term_is_valid
    params[:term] && !params[:term].empty?
  end

  def specializations
    @specializations ||= if term_is_valid
                           term = "#{params[:term].downcase}%"
                           Specialization.where('lower(title) like ?', term)
                                         .order(title: :asc)
                         else
                           Specialization.order(title: :asc)
                         end
  end

  def set_authorize
    authorize [:admin, :specialization]
  end
end
