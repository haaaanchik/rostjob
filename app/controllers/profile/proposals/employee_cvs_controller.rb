class Profile::Proposals::EmployeeCvsController < ApplicationController
  def index
    @list = EmployeeCv.where profile_id: current_profile.id
  end

  def new
    proposal
    @employee_cv = EmployeeCv.new
  end

  def show
  end

  def edit
    render js: 'alert("edit!")'
  end

  def create
    @cv = employee_cvs.build(employee_cvs_params.merge(profile_id: current_profile.id))
    if @cv.save
      render @cv, layout: false
    else
      render json: @cv.errors.messages, status: 422
    end
  end

  def update
  end

  private

  def employee_cvs_params
    params.require(:employee_cv).permit(:name, :gender, :birthdate, :file, ext_data: {})
  end

  def employee_cvs
    @employee_cvs ||= proposal.employee_cvs
  end

  def proposal
    @proposal ||= proposals.find(params[:proposal_id])
  end

  def proposals
    @proposals ||= current_profile.proposals
  end
end
