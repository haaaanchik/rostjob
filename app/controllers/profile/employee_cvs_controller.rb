class Profile::EmployeeCvsController < ApplicationController
  def index
    @list = EmployeeCv.where profile_id: current_profile.id
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
    @employee_cv.update_attributes proposal_id: params[:proposal_id], state: :applyed
  end

  def remove_proposal
    @employee_cv = EmployeeCv.find_by id: params[:id]
    @employee_cv.update_attributes proposal_id: nil, state: :draft
  end

  private

  def employee_cvs_params
    params.require(:employee_cv).permit(:proposal_id, :name, :gender,
                                        :birthdate, :file, ext_data: {})
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
