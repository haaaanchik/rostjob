class Profile::ProposalEmployeesController < ApplicationController
  def show
    proposal_employee
    @remained_warranty_days = Holiday.remained_warranty_days(@proposal_employee.hiring_date,
                                                             @proposal_employee.warranty_date)
  end

  def to_disput
    proposal_employee.to_disputed!
    ecv = proposal_employee.employee_cv
    ecv.to_disputed!
    redirect_to profile_employee_cvs_path(term: :disputed)
  end

  def revoke
    Cmd::ProposalEmployee::Revoke.call(proposal_employee: proposal_employee, log: true)
    Cmd::EmployeeCv::ToReady.call(employee_cv: proposal_employee.employee_cv)
    # redirect_to profile_employee_cvs_path(term: :ready)
  end

  private

  def proposal_employee
    @proposal_employee ||= proposal_employees.find(params[:id])
  end

  def proposal_employees
    @proposal_employees = ProposalEmployee.where(profile_id: current_profile.id).order(id: :desc)
  end
end
