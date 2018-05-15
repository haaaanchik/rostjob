class Profile::Proposals::EmployeeCvsController < ApplicationController
  def index
    employee_cvs
  end

  def new
    proposal
    @employee_cv = EmployeeCv.new
  end

  def show
  end

  def create
    @cv = employee_cvs.build(employee_cvs_params)
    if @cv.save
      redirect_to profile_proposal_employee_cvs_path(proposal)
    else
      render 'index'
    end
  end

  def update
  end

  private

  def employee_cvs_params
    params.require(:employee_cv).permit(:name, :gender, :birthdate, :file)
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
