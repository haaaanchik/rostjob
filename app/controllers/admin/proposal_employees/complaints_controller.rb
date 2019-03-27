class Admin::ProposalEmployees::ComplaintsController < Admin::ApplicationController
  def close
    complaint.to_closed!
  end

  private

  def complaint
    @complaint ||= proposal_employee.complaints.find(params[:id])
  end

  def proposal_employee
    ProposalEmployee.find(params[:proposal_employee_id])
  end
end
