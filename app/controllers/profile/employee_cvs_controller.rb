# frozen_string_literal: true

class Profile::EmployeeCvsController < ApplicationController
  before_action :set_authorize
  before_action :employee_cvs, only: :index

  def index
    @favorites = current_profile.favorites.includes(:employee_cvs, :production_site).decorate
    @active_item = term
    @crm_columns = current_user.crm_columns.includes(:employee_cvs)
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
    result = Cmd::EmployeeCv::CreateAsReady.call(profile: current_profile,
                                                 employee_cvs_params: employee_cvs_params)
    if result.success?
      @status = 'success'
      redirect_to profile_employee_cvs_path
    else
      @status = 'error'
      render json: { validate: true, data: errors_data(result.employee_cv) }, status: 422
    end
  end

  def create_for_send
    result = Cmd::EmployeeCv::Send.call(employee_cvs_params: employee_cvs_params,
                                        interview_date: params[:interview_date],
                                        profile: current_profile,
                                        order: employee_cv_order)

     @status = result.success? ? 'success' : 'fail'
  end

  def update
    result = Cmd::EmployeeCv::Update.call(employee_cv: employee_cv, params: employee_cvs_params)
    if result.success?
      redirect_after_update

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
    @result = Cmd::EmployeeCv::ToDeleted.call(employee_cv: employee_cv)
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
                  :photo, :document, :remark, :education, :experience, :reminder, :comment,
                  crm_columns_employee_cv_attributes: [:crm_column_id])
  end

  def term
    @term = :employee_lists
  end

  def employee_cvs
    @q = EmployeeCv
           .where(profile_id: current_profile.id, state: :ready)
           .where('id NOT IN (SELECT employee_cv_id FROM crm_columns_employee_cvs)')
           .ransack(params[:q])

    @paginated_employee_cvs = @q.result(distinct: true)
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

  def set_authorize
    authorize [:profile, :employee_cv]
  end

  def redirect_after_update
    return unless params[:employee_cv][:redirected]

    case params[:employee_cv][:redirected]
    when 'to_profile_proposal_employees'
      redirect_to profile_proposal_employees_path, notice: 'Анкета обновлена', format: 'js'
    when 'to_incident'
      redirect_back(fallback_location: profile_tickets_path)
    end
  end
end
