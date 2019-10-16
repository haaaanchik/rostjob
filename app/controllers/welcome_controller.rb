class WelcomeController < ApplicationController
  # skip_before_action :authenticate_user!
  skip_before_action :auth_user

  def index
    @user = User.new
    if user_signed_in?
      prepare_data
      user_action_log_records
    end
    @active_item = :root
    production_site
  end

  private

  def user_action_log_records
    @user_action_log_records ||= UserActionLog.where('JSON_CONTAINS(receiver_ids, ?) = 1', current_user.id.to_s)
                                              .order(id: :desc)
                                              .page(params[:page]).per(10)
                                              .decorate
  end

  def prepare_data
    if current_profile.customer?
      orders_with_unviewed_pe_count
      orders_with_disputed_employee_cvs
      customer_deals_count
      orders_with_interviewed_candidates
    elsif current_profile.contractor?
      orders_with_transfering_employee_cvs
      orders_with_disputed_employee_cvs
      orders_with_deleted_employee_cvs
      contractor_deals_count
    end
  end

  def orders_with_transfering_employee_cvs
    @orders_with_transfering_employee_cvs ||= current_profile.answered_orders.with_transfering_employee_cvs_contractor
  end

  def orders_with_interviewed_candidates
    @orders_with_interviewed_candidates = current_profile.orders.with_interviewed_candidates.order('interview_date')
  end

  def contractor_deals_count
    @contractor_deals_count ||= current_profile.proposal_employees.paid.count
  end

  def customer_deals_count
    @customer_deals_count ||= 1
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

  def orders_with_deleted_employee_cvs
    @orders_with_deleted_employee_cvs ||= current_profile.answered_orders.with_deleted_employee_cvs_contractor
  end

  def production_site
    @production_site ||= current_profile.production_sites.find(params[:prod_site_id]) if params[:prod_site_id].present?
  end
end
