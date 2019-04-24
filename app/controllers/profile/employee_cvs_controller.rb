class Profile::EmployeeCvsController < ApplicationController
  # layout false, only: :index

  def index
    if term == :sent
      paginated_sent_employee_cvs
      render 'profile/employee_cvs/sent_index'
    else
      paginated_employee_cvs
      @active_item = term.to_sym
    end
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

  def new_full
    @employee_cv = EmployeeCv.new employee_cvs_params
    # FIXME: refactor this asap
    order2 if employee_cvs_params[:order_id]
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
    else
      @status = 'error'
      # @text = error_msg_handler result.employee_cv
      render json: { validate: true, data: errors_data(result.employee_cv) }
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
      render json: { validate: true, data: errors_data(result.employee_cv) }
    end

    # ecv_result = Cmd::EmployeeCv::CreateAsReady.call(params: employee_cvs_params, profile: current_profile)
    # order_result = Cmd::Order::AddToFavorites.call(order: order2, profile: current_profile)
    # result = Cmd::ProposalEmployee::Create.call(profile: current_profile, params: { employee_cv_id: ecv_result.employee_cv.id, order_id: order_result.order.id, arrival_date: arrival_date })
    # @employee_cv = ecv_result.employee_cv
    # @employee_pr = result.employee_pr
    # if result.success?
    #   Cmd::EmployeeCv::ToSent.call(employee_cv: ecv_result.employee_cv, log: false)
    #   @status = 'success'
    #   # redirect_to profile_employee_cvs_path(term: :sent)
    # else
    #   @status = 'error'
    #   render json: { validate: true, data: errors_data(result.employee_cv) }
    #   # @text = error_msg_handler ecv_result.employee_cv
    # end
  end

  def update
    result = Cmd::EmployeeCv::Update.call(employee_cv: employee_cv, params: employee_cvs_params)
    if result.success?
      @status = 'success'
    else
      @status = 'error'
      # @text = error_msg_handler result.employee_cv
      render json: { validate: true, data: errors_data(result.employee_cv) }
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
    @employee_cv ||= EmployeeCv.find(params[:id])
  end

  def employee_cvs_params
    params.require(:employee_cv)
          .permit(:phone_number, :contractor_terms_of_service, :proposal_id, :order_id,
                  :name, :gender, :mark_ready, :birthdate, :photo, :document, :remark, :arrival_date,
                  :education, :phone_number_alt, :experience, ext_data: {}, passport: {})
  end

  def states_by_term
    EmployeeCv.contractor_menu_items[term]
  end

  def term
    # term = params[:term]
    # @term = if !term
    #           :ready
    #         elsif term.empty?
    #           :ready
    #         else
    #           EmployeeCv.contractor_menu_items.include?(term.to_sym) ? term.to_sym : :ready
    #         end
    @term = params[:employee_cv_state]
  end

  def paginated_employee_cvs
    @paginated_employee_cvs ||= scoped_employee_cvs.page(params[:page])
  end

  def paginated_sent_employee_cvs
    @paginated_sent_employee_cvs ||= sent_employee_cvs.page(params[:page])
  end

  def scoped_employee_cvs
    # @scoped_employee_cvs ||= employee_cvs.where(state: term)
    @scoped_employee_cvs ||= employee_cvs.where(state: params[:employee_cv_state])
  end

  def sent_employee_cvs
    @sent_employee_cvs = ProposalEmployee.where(profile_id: current_profile.id).where.not(state: 'revoked').order(id: :desc)
  end

  def employee_cvs
    @q = EmployeeCv.where(profile_id: current_profile.id).order(id: :desc).ransack(params[:q])
    @employee_cvs ||= @q.result
  end

  def order
    @order ||= Order.find(params[:order_id])
  end

  def order2
    @order ||= Order.find_by(id: employee_cvs_params[:order_id])
  end

  def arrival_date
    employee_cvs_params[:arrival_date]
  end
end
