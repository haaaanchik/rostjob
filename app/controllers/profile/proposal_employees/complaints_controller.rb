class Profile::ProposalEmployees::ComplaintsController < ApplicationController
  def index
    complaints
    @complaint = Complaint.new
  end

  def create
    complaint = complaints.create(complaints_params.merge(profile: current_profile))
    if complaint.persisted?
      proposal_employee.to_disputed! if proposal_employee.may_to_disputed?
      @status = 'success'
    else
      @text = error_msg_handler complaint
    end
  end

  private

  def complaints_params
    params.require(:complaint).permit(:text)
  end

  def complaints
    @complaints ||= proposal_employee.complaints
  end

  def proposal_employee
    @proposal_employee ||= ProposalEmployee.find(params[:proposal_employee_id])
  end
end
