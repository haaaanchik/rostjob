class Admin::StaffersController < Admin::ApplicationController
  def index
    staffers
  end

  def new
    @staffer = Staffer.new
  end

  def edit
    staffer
  end

  def create
    @staffer = Staffer.create(staffer_params)
    if @staffer.errors.messages.any?
      render json: {validate: true, data: errors_data(@staffer)}
    else
      redirect_to admin_staffers_path
    end
  end

  def update
    staffer.update(staffer_params)
    if staffer.errors.messages.any?
      render json: {validate: true, data: errors_data(staffer)}
    else
      redirect_to admin_staffers_path
    end
  end

  def destroy
    staffer.destroy
    redirect_to admin_staffers_path
  end

  private

  def staffer_params
    params.require(:staffer).permit(:name, :login, :password, staffer_roles: [])
  end

  def staffer
    @staffer ||= staffers.find(params[:id])
  end

  def staffers
    @staffers ||= Staffer.all
  end
end
