class Profile::EmployeeCvsController < ApplicationController
  def index
    @list = EmployeeCv.where profile_id: current_profile.id
  end

  def show
    @employee_cv = EmployeeCv.find(params[:id])
    @remained_warranty_days = Holiday.remained_warranty_days(@employee_cv.hiring_date, @employee_cv.warranty_date)
  end

  def new
    @employee_cv = EmployeeCv.new proposal_id: params[:proposal_id]
  end

  def edit
    @employee_cv = EmployeeCv.find_by id: params[:id]
  end

  def create
    @employee_cv = EmployeeCv.new employee_cvs_params.merge(profile_id: current_profile.id)
    if @employee_cv.save
      @status = 'success'
      @employee_cv.make_ready! if params[:save]
    else
      @status = 'error'
      @text = error_msg_handler @employee_cv
    end
  end

  def update
    @employee_cv = EmployeeCv.find_by id: params[:id]
    if @employee_cv.update_attributes employee_cvs_params
      @status = 'success'
    else
      @status = 'error'
      @text = error_msg_handler @employee_cv
    end
  end

  def destroy
    @employee_cv = EmployeeCv.find_by id: params[:id]
    @employee_cv.destroy
  end

  def add_proposal
    @employee_cv = EmployeeCv.find_by id: params[:id]
    @employee_pr = @employee_cv.create_pr_empl params[:proposal_id]
    @employee_cv.apply!
    if @employee_cv.errors.none?
      @status = 'success'
    else
      @status = 'error'
      @text = error_msg_handler @employee_cv
    end
  end

  def remove_proposal
    @employee_cv = EmployeeCv.find_by id: params[:id]
    @employee_cv.rempve_pr_empl params[:proposal_id]
  end

  def change_status
    @employee_cv = ProposalEmployee.find_by id: params[:id]
    return if %w[hired].include?(params[:state])
    @employee_cv.update_attributes state: params[:state]
  end

  private

  def employee_cvs_params
    params.require(:employee_cv).permit(:phone_number, :contractor_terms_of_service, :proposal_id,
                                        :name, :gender, :mark_ready, :birthdate, :file, ext_data: {})
  end

  def employee_cvs
    @employee_cvs ||= proposal.employee_cvs
  end

  # def proposal
  #   @proposal ||= proposals.find(params[:proposal_id])
  # end
  #
  # def proposals
  #   @proposals ||= current_profile.proposals
  # end
end
