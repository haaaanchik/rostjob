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

  def create
    Cmd::Order::AddToFavorites.call(order: order, profile: current_profile)
    result = Cmd::ProposalEmployee::Create.call(profile: current_profile, params: proposal_employee_params)
    @employee_cv = employee_cv
    if result.success?
      Cmd::EmployeeCv::ToSent.call(employee_cv: @employee_cv, log: false)
      @status = 'success'
      # redirect_to profile_employee_cvs_path(term: :ready)
    else
      @status = 'error'
      render json: { validate: true, data: errors_data(result.proposal_employee) }
    end
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

  def proposal_employee_params
    params.require(:proposal_employee).permit(:order_id, :employee_cv_id, :arrival_date)
  end

  def order
    @order ||= Order.find(proposal_employee_params[:order_id])
  end

  def employee_cv
    @employee_cv ||= current_profile.employee_cvs.find(proposal_employee_params[:employee_cv_id])
  end

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
