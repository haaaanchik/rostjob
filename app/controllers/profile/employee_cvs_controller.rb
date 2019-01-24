class Profile::EmployeeCvsController < ApplicationController
  def index
    if term == :sent
      paginated_sent_employee_cvs
      render 'profile/employee_cvs/sent_index'
    else
      paginated_employee_cvs
    end
  end

  def show
    @employee_cv = EmployeeCv.find(params[:id])
    @remained_warranty_days = Holiday.remained_warranty_days(@employee_cv.hiring_date, @employee_cv.warranty_date)
  end

  def new
    @employee_cv = EmployeeCv.new proposal_id: params[:proposal_id]
  end

  def edit
    @employee_cv = EmployeeCv.find_by id: params[:id]
  end

  def create
    @employee_cv = EmployeeCv.new employee_cvs_params.merge(profile_id: current_profile.id)
    if @employee_cv.save
      @status = 'success'
      if params[:save]
        @employee_cv.to_ready!
        redirect_to profile_employee_cvs_path(term: :ready)
      else
        redirect_to profile_employee_cvs_path(term: :draft)
      end
    else
      @status = 'error'
      @text = error_msg_handler @employee_cv
    end
  end

  def update
    @employee_cv = EmployeeCv.find_by id: params[:id]
    if @employee_cv.update_attributes employee_cvs_params
      @status = 'success'
    else
      @status = 'error'
      @text = error_msg_handler @employee_cv
    end
  end

  def destroy
    @employee_cv = EmployeeCv.find_by id: params[:id]
    @employee_cv.to_deleted!
    # redirect_to profile_employee_cvs_path(term: term)
  end

  def add_proposal
    @employee_cv = EmployeeCv.find_by id: params[:id]
    @employee_pr = @employee_cv.create_pr_empl params[:proposal_id]
    @employee_cv.to_sent!
    if @employee_cv.errors.none?
      @status = 'success'
      redirect_to profile_employee_cvs_path(term: :ready)
    else
      @status = 'error'
      @text = error_msg_handler @employee_cv
    end
  end

  def remove_proposal
    @employee_cv = EmployeeCv.find_by id: params[:id]
    @employee_cv.rempve_pr_empl params[:proposal_id]
  end

  def change_status
    @proposal_employee_cv = ProposalEmployee.find_by id: params[:id]
    return if %w[hired].include?(params[:state])
    @proposal_employee_cv.update_attributes state: params[:state]
  end

  def to_ready
    if employee_cv.to_ready!
      @status = 'success'
      redirect_to profile_employee_cvs_path(term: :ready)
    else
      @status = 'error'
      @text = error_msg_handler @employee_cv
    end
  end

  def to_disput
    if employee_cv.disput!
      @status = 'success'
      redirect_to profile_employee_cvs_path(term: :disputed)
    else
      @status = 'error'
      @text = error_msg_handler @employee_cv
    end
  end

  private

  def employee_cv
    @employee_cv ||= EmployeeCv.find(params[:id])
  end

  def employee_cvs_params
    params.require(:employee_cv)
          .permit(:phone_number, :contractor_terms_of_service, :proposal_id,
                  :name, :gender, :mark_ready, :birthdate, :file, ext_data: {})
  end

  def states_by_term
    EmployeeCv.contractor_menu_items[term]
  end

  def term
    term = params[:term]
    @term = if !term
              :ready
            elsif term.empty?
              :ready
            else
              EmployeeCv.contractor_menu_items.include?(term.to_sym) ? term.to_sym : :ready
            end
  end

  def paginated_employee_cvs
    @paginated_employee_cvs ||= scoped_employee_cvs.page(params[:page])
  end

  def paginated_sent_employee_cvs
    @paginated_sent_employee_cvs ||= sent_employee_cvs.page(params[:page])
  end

  def scoped_employee_cvs
    @scoped_employee_cvs ||= employee_cvs.where(state: term)
  end

  def sent_employee_cvs
    @sent_employee_cvs = ProposalEmployee.where(profile_id: current_profile.id).where.not(state: 'revoked').order(id: :desc)
  end

  def employee_cvs
    @employee_cvs = EmployeeCv.where(profile_id: current_profile.id).order(id: :desc)
  end
end
