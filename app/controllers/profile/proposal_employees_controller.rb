class Profile::ProposalEmployeesController < ApplicationController
  layout false, only: :index

  def index
    paginated_proposal_employees
  end

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
    result = Cmd::ProposalEmployee::Revoke.call(proposal_employee: proposal_employee, log: true)
    if result.success?
      Cmd::EmployeeCv::ToReady.call(employee_cv: proposal_employee.employee_cv)
      @status = 'success'
    else
      @status = 'error'
    end
    # redirect_to profile_employee_cvs_path(term: :ready)
  end

  private

  def proposal_employee
    @proposal_employee ||= proposal_employees.find(params[:id])
  end

  def paginated_proposal_employees
    @paginated_proposal_employees ||= proposal_employees.page(params[:page]).per(10).decorate
  end

  def proposal_employees
    @q = ProposalEmployee.where(profile_id: current_profile.id, state: %w[inbox hired disputed]).order(id: :desc).ransack(params[:q])
    @proposal_employees ||= @q.result
  end
end
