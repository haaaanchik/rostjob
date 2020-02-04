class Admin::ProposalEmployeesController < Admin::ApplicationController
  def index
    proposal_employees
  end

  def show
    proposal_employee
  end

  def approve_act
    @result = Cmd::ProposalEmployee::AdminApproval.call(candidate: proposal_employee)
  end

  def approval_list
    @approval_list = ProposalEmployee.includes(:order, :employee_cv)
                         .approved_by_admin
                         .page(params[:page]).per(10)
  end

  private

  def proposal_employee
    @proposal_employee ||= ProposalEmployee.find(params[:id]).decorate
  end

  def proposal_employees
    @proposal_employees ||= ProposalEmployee.with_last_complaint_time
                                            .page(params[:page]).decorate
  end
end
