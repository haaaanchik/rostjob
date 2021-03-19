# frozen_string_literal: true

class Admin::ProposalEmployeesController < Admin::ApplicationController
  before_action :set_authorize

  def index
    paginated_proposal_employees
    @active_item = :candidates
  end

  def approve_act
    @result = Cmd::ProposalEmployee::AdminApproval.call(candidate: proposal_employee)
  end

  def approval_list
    @approval_list = ProposalEmployee.includes(:employee_cv, order: :production_site)
                                      .where(state: :paid, approved_by_admin: false)
                                      .page(params[:page]).per(10)
  end

  def revoke
    @result = Cmd::ProposalEmployee::Revoke.call(user: current_staffer.decorate,
                                                 proposal_employee: proposal_employee)
    @action = 'отозват'
    render_after_update
  end

  def hire
    @result = Cmd::ProposalEmployee::Hire.call(candidate: proposal_employee,
                                               user: current_staffer.decorate,
                                               order: proposal_employee.order,
                                               hiring_date: params[:proposal_employee][:hiring_date])
    @action = 'нанят'
    render_after_update
  end

  def approve
    @result = Cmd::ProposalEmployee::Approval.call(candidate: proposal_employee)
    @action = 'подтверждён'
    render_after_update
  end

  def paid
    @result = Cmd::ProposalEmployee::Pay.call(candidate: proposal_employee,
                                              user: current_staffer.decorate)
    @action = 'оплачен'
    render_after_update
  end


  private

  def proposal_employee
    @proposal_employee ||= ProposalEmployee.find(params[:id]).decorate
  end

  def paginated_proposal_employees
    @paginated_proposal_employees ||= proposal_employees
                                      .page(params[:page])
                                      .per(10)
                                      .includes(order: :production_site)
                                      .decorate
  end

  def proposal_employees
    @q = ProposalEmployee.reorder(created_at: :desc).ransack(params[:q])
    @proposal_employees ||= @q.result
  end

  def render_after_update
    respond_to do |format|
      format.js { render partial: 'admin/proposal_employees/after_update.js.erb' }
    end
  end

  def set_authorize
    authorize %i[admin proposal_employee]
  end
end
