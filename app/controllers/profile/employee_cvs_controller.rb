class Profile::EmployeeCvsController < ApplicationController
  before_action :employee_cvs, only: :index

  def index
    @order_profiles = current_profile.order_profiles.includes(order: :employee_cvs)
    @active_item = term
  end

  def show
    @employee_cv = EmployeeCv.find(params[:id])
    @remained_warranty_days = Holiday.remained_warranty_days(@employee_cv.hiring_date, @employee_cv.warranty_date)
  end

  def new
    @employee_cv = EmployeeCv.new proposal_id: params[:proposal_id]
    # FIXME: refactor this asap
    order if params[:order_id]
  end

  def pre_new_full
    flash['params'] = employee_cvs_params
    redirect_to new_full_profile_employee_cv_path
  end

  def new_full
    ecv_params = flash['params']
    @employee_cv = EmployeeCv.new ecv_params
    # FIXME: refactor this asap
    if ecv_params
      @order ||= Order.find_by(id: ecv_params['order_id']) if !ecv_params['order_id'].nil? || !ecv_params['order_id'].empty?
    end
  end

  def edit
    @employee_cv = EmployeeCv.find_by id: params[:id]
  end

  def create_as_draft
    result = Cmd::EmployeeCv::CreateAsDraft.call(params: employee_cvs_params, profile: current_profile)
    if result.success?
      @status = 'success'
      redirect_to profile_employee_cvs_path(term: :draft)
    else
      @status = 'error'
      @text = error_msg_handler result.employee_cv
    end
  end

  def create_as_ready
    result = Cmd::EmployeeCv::CreateAsReady.call(params: employee_cvs_params, profile: current_profile)
    if result.success?
      @status = 'success'
      # redirect_to profile_employee_cvs_path(term: :ready)
      redirect_to profile_employee_cvs_path
    else
      @status = 'error'
      # @text = error_msg_handler result.employee_cv
      render json: { validate: true, data: errors_data(result.employee_cv) }, status: 422
    end
  end

  # FIXME: Refactor this beautiful code ASAP!!!
  def create_for_send
    order2
    result = Cmd::EmployeeCv::CreateAsReady.call(params: employee_cvs_params, profile: current_profile)
    @employee_cv = result.employee_cv
    if result.success?
      @status = 'success'
      # redirect_to profile_employee_cvs_path(term: :ready)
    else
      @status = 'error'
      # @text = error_msg_handler result.employee_cv
      render json: { validate: true, data: errors_data(result.employee_cv) }, status: 422
    end
  end

  def update
    result = Cmd::EmployeeCv::Update.call(employee_cv: employee_cv, params: employee_cvs_params)
    if result.success?
      @status = 'success'
    else
      @status = 'error'
      # @text = error_msg_handler result.employee_cv
      render json: { validate: true, data: errors_data(result.employee_cv) }, status: 422
    end
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
    result = Cmd::EmployeeCv::ToReady.call(employee_cv: employee_cv)
    if result.success?
      @status = 'success'
      # redirect_to profile_employee_cvs_path(term: :ready)
    else
      @status = 'error'
      @text = error_msg_handler result.employee_cv
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
                  :photo, :document, :remark, :education, :experience, :reminder)
  end

  def term
    @term = :employee_lists
  end

  def employee_cvs
    @q = EmployeeCv.where(profile_id: current_profile.id, state: %w(ready deleted)).order(id: :desc).ransack(params[:q])
    @paginated_employee_cvs = @q.result
  end

  def order
    @order = Order.find(params[:order_id])
  end

  def order2
    @order = Order.find_by(id: employee_cvs_params[:order_id])
  end

  def arrival_date
    employee_cvs_params[:arrival_date]
  end
end
