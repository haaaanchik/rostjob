class Profile::ProposalEmployeesController < ApplicationController
  before_action :set_authorize
  # layout false, only: :index

  def index
    paginated_proposal_employees
    @active_item = :sent
  end

  def show
    proposal_employee
    @remained_warranty_days = Holiday.remained_warranty_days(@proposal_employee.hiring_date,
                                                             @proposal_employee.warranty_date)
    @redirect = params[:redirect] || 'to_profile_proposal_employees'
  end

  def new
    @proposal_employee = current_profile.proposal_employees.build
    @proposal_employee.build_employee_cv
    order2
  end

  def create
    result = Cmd::ProposalEmployee::Create.call(order: order,
                                                employee_cv: employee_cv,
                                                profile: current_profile,
                                                interview_date: proposal_employee_params[:interview_date])

    @employee_cv = employee_cv

    if result.success?
      @status = 'success'
      render json: { pr_employee_id: result.proposal_employee.id } if params[:draggable]
      # redirect_to profile_employee_cvs_path(term: :ready)
    else
      @status = 'error'
      render json: { validate: true, data: errors_data(result.proposal_employee) }, status: 422
    end
  end

  def correct_interview_date
    result = Cmd::ProposalEmployee::CorrectInterviewDate.call(proposal_employee: proposal_employee,
                                                              interview_date: proposal_employee_params[:interview_date])
    if result.success?
      @result_success = true
    end
  end

  def to_disput
    proposal_employee.to_disputed!
    ecv = proposal_employee.employee_cv
    ecv.to_disputed!
    redirect_to profile_employee_cvs_path(term: :disputed)
  end

  def revoke
    result = Cmd::ProposalEmployee::Revoke.call(proposal_employee: proposal_employee, user: current_user)
    if result.success?
      @status = 'success'
      render json: { revoke: 'success' } if params[:draggable]
    else
      @status = 'error'
      render json: {validate: true, revoke: 'error' }, status: 422 if params[:draggable]
    end
  end

  def approve_transfer
    result = Cmd::ProposalEmployee::ApproveTransfer.call(candidate: proposal_employee)
    @status = result.success? ? true : false
  end

  private

  def proposal_employee_params
    params.require(:proposal_employee).permit(:order_id, :employee_cv_id, :interview_date, employee_cv_attributes: [])
  end

  def order
    @order ||= Order.find(proposal_employee_params[:order_id])
  end

  def order2
    @order2 ||= Order.find(params[:order_id])
  end

  def employee_cv
    @employee_cv ||= current_profile.employee_cvs.find(proposal_employee_params[:employee_cv_id])
  end

  def proposal_employee
    @proposal_employee ||= ProposalEmployee.where(profile_id: current_profile.id).find(params[:id]).decorate
  end

  def paginated_proposal_employees
    @paginated_proposal_employees ||= proposal_employees.page(params[:page]).decorate
  end

  def proposal_employees
    @q = ProposalEmployee.where(profile_id: current_profile.id)
           .where.not(state: 'revoked')
           .order("proposal_employees.state = 'disputed' desc, id desc").ransack(params[:q])
    @proposal_employees ||= @q.result
  end

  def set_authorize
    authorize [:profile, :proposal_employee]
  end
end
