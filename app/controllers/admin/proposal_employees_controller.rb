class Admin::ProposalEmployeesController < Admin::ApplicationController
  def index
    proposal_employees
  end

  def show
    proposal_employee
  end

  private

  def scope(scope)
    return :none if scope.nil? || scope.empty?
    state = scope.to_sym
    states = ProposalEmployee.aasm.states.map(&:name)
    states.include?(state) ? state : :none
  end

  def proposal_employee
    @proposal_employee ||= ProposalEmployee.find(params[:id])
  end

  def proposal_employees
    @proposal_employees ||= ProposalEmployee.send(scope(params[:scope]))
                                            .page(params[:page]).decorate
  end
end
