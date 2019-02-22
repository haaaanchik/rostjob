class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :auth_user

  def index
    if user_signed_in?
      prepare_data
      user_action_log_records
    end
  end

  private

  def user_action_log_records
    @user_action_log_records ||= UserActionLog.where('JSON_CONTAINS(receiver_ids, ?) = 1', current_user.id.to_s)
                                              .order(id: :desc)
                                              .page(params[:page])
                                              .decorate
  end

  def prepare_data
    if current_profile.customer?
      orders_with_unviewed_pe_count
      orders_with_disputed_employee_cvs
      # binding.pry
    elsif current_profile.contractor?
      orders_with_disputed_employee_cvs
      orders_with_deleted_employee_cvs
    end
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
end
