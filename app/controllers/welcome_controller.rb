# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_before_action :auth_user, only: :index

  def index
    @user = User.new
    if user_signed_in?
      @profile = current_profile.decorate
      prepare_data if current_profile.customer?
      user_action_log_records
    end
    @active_item = :root
    production_site
  end

  def calendar_events
    @empl_cv_hired = proposal_employee.hired.range_hiring(params[:start], params[:end]).decorate
    @empl_cv_interview = proposal_employee.interview.range_interview(params[:start], params[:end]).decorate
    @empl_cv_inbox = proposal_employee.inbox.range_inbox(params[:start], params[:end]).decorate
    @empl_cv_approved = proposal_employee.approved.range_approved(params[:start], params[:end]).decorate
    @empl_cv_reminders = current_profile.employee_cvs.ready.range_reminders(params[:start], params[:end])
  end

  def loading_candidates_interview
    prepare_data

    render layout: false
  end

  private

  def user_action_log_records
    @user_action_log_records ||= UserActionLog.json_contain_receiver_ids(current_user)
                                              .order(id: :desc)
                                              .page(params[:page])
                                              .per(10)
                                              .decorate
  end

  def proposal_employee
    current_profile.proposal_employees
  end

  def prepare_data
    @candidates_interview = current_profile.orders.with_interviewed_candidates.order('interview_date asc')
                                           .includes(:production_site)
                                           .page(params[:page])
  end

  def orders_with_disputed_employee_cvs
    @orders_with_disputed_employee_cvs ||= if current_profile.customer?
                                             current_profile.orders.with_disputed_employee_cvs
                                           elsif current_profile.contractor?
                                             current_profile.answered_orders.with_disputed_employee_cvs_contractor
    end
  end

  def production_site
    @production_site ||= current_profile.production_sites.find(params[:prod_site_id]) if params[:prod_site_id].present?
  end
end
