class Profile::EmployeeCvsController < ApplicationController
  before_action :employee_cvs, only: :index
  before_action :employee_cv_order, only: :create_for_send

  def index
    @favorites = current_profile.favorites.includes(:employee_cvs, :production_site).decorate
    @active_item = term
    @proposal_employee = ProposalEmployee.find_by(id: params[:proposal_employee_id])
    @param_employee_cv = EmployeeCv.find_by(id: params[:employee_cv_id], profile_id: current_profile.id)
  end

  def new
    @employee_cv = EmployeeCv.new proposal_id: params[:proposal_id]
    # FIXME: refactor this asap
    order if params[:order_id]
  end

  def edit
    @employee_cv = EmployeeCv.find_by(id: params[:id]).decorate
  end

  def create_as_ready
    result = Cmd::EmployeeCv::CreateAsReady.call(params: employee_cvs_params, profile: current_profile)
    if result.success?
      @status = 'success'
      redirect_to profile_employee_cvs_path
    else
      @status = 'error'
      render json: { validate: true, data: errors_data(result.employee_cv) }, status: 422
    end
  end

  def create_for_send
    result = Cmd::EmployeeCv::CreateAsReady.call(params: employee_cvs_params,
                                                 profile: current_profile,
                                                 interview_date: params[:interview_date],
                                                 order: @order, current_profile: current_profile)
    @employee_cv = result.employee_cv
    if result.success?
      @status = 'success'
    else
      render json: { validate: true, data: errors_data(result.employee_cv) }, status: 422
    end
  end

  def update
    result = Cmd::EmployeeCv::Update.call(employee_cv: employee_cv, params: employee_cvs_params)
    if result.success?
      @status = 'success'
      render json: { reminder_date: result.employee_cv.decorate.display_reminders } if params[:draggable]
    else
      @status = 'error'
      render json: { validate: true, data: errors_data(result.employee_cv) }, status: 422
    end
  end

  def reset_reminder
    employee_cv.update(comment: nil, reminder: nil)
    redirect_to profile_employee_cvs_path
  end

  def destroy
    result = Cmd::EmployeeCv::ToDeleted.call(employee_cv: employee_cv)
    @employee_cv = result.employee_cv
    # redirect_to profile_employee_cvs_path(term: term)
  end

  def change_status
    @proposal_employee_cv = ProposalEmployee.find_by id: params[:id]
    return if %w[hired].include?(params[:state])
    @proposal_employee_cv.update_attributes state: params[:state]
  end

  def to_ready
    result = Cmd::EmployeeCv::ToReady.call(employee_cv: employee_cv, draggable: eval(params[:draggable]))
    if result.success?
      @status = 'success'
      render json: { data: @status } if params[:draggable]
    else
      @status = 'error'
      @text = error_msg_handler result.employee_cv
      render json: { validate: true, data: @text }, status: 422 if params[:draggable]
    end
  end

  def to_disput
    result = Cmd::EmployeeCv::ToDisput.call(employee_cv: employee_cv)
    if result.success?
      @status = 'success'
      redirect_to profile_employee_cvs_path(term: :ready)
    else
      @status = 'error'
      @text = error_msg_handler result.employee_cv
    end
  end

  private

  def employee_cv
    @employee_cv = EmployeeCv.find(params[:id])
  end

  def employee_cvs_params
    params.require(:employee_cv)
          .permit(:email, :phone_number, :proposal_id, :order_id, :name, :gender, :mark_ready,
                  :photo, :document, :remark, :education, :experience, :reminder, :comment)
  end

  def term
    @term = :employee_lists
  end

  def employee_cvs
    @q = EmployeeCv.where(profile_id: current_profile.id, state: %w(ready deleted)).ransack(params[:q])
    @paginated_employee_cvs = @q.result
  end

  def order
    @order = Order.find(params[:order_id])
  end

  def employee_cv_order
    @order = Order.find_by(id: employee_cvs_params[:order_id])
  end

  def arrival_date
    employee_cvs_params[:arrival_date]
  end
end
