class Admin::ProposalEmployeesController < Admin::ApplicationController
  def index
    proposal_employees
  end

  def show
    proposal_employee
  end

  private

  def proposal_employee
    @proposal_employee ||= ProposalEmployee.find(params[:id])
  end

  def proposal_employees
    @proposal_employees ||= ProposalEmployee.with_last_complaint_time
                                            .page(params[:page]).decorate
  end
end
