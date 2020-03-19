class WelcomeController < ApplicationController
  skip_before_action :auth_user

  def index
    @user = User.new
    if user_signed_in?
      prepare_data if current_profile.customer?
      user_action_log_records
    end
    @active_item = :root
    production_site
  end

  def calendar_events
    @logs = UserActionLog.json_contain_receiver_ids(current_user).log_range(params[:start], params[:end]).decorate
  end

  private

  def user_action_log_records
    @user_action_log_records ||= UserActionLog.json_contain_receiver_ids(current_user)
                                              .order(id: :desc)
                                              .page(params[:page]).per(10)
                                              .decorate
  end

  def prepare_data
    orders_with_unviewed_pe_count
    orders_with_interviewed_candidates
  end

  def orders_with_interviewed_candidates
    @orders_with_interviewed_candidates = current_profile.orders.with_interviewed_candidates.order('interview_date')
  end

  def orders_with_unviewed_pe_count
    @orders_with_unviewed_pe_count ||= current_profile.orders.with_unviewed_pe_count
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
