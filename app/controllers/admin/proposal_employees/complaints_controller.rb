class Admin::ProposalEmployees::ComplaintsController < Admin::ApplicationController
  def close
    complaint.to_closed!
    if all_complaints_closed?
      proposal_employee.hire!
      redirect_to admin_proposal_employees_path(scope: :disputed)
    end
  end

  private

  def all_complaints_closed?
    @all_complaints_closed ||= proposal_employee.complaints.opened.none?
  end

  def complaint
    @complaint ||= proposal_employee.complaints.find(params[:id])
  end

  def proposal_employee
    ProposalEmployee.find(params[:proposal_employee_id])
  end
end
