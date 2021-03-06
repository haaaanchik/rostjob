class Admin::ApplicationController < BaseController
  include Admin::SessionsHelper

  protect_from_forgery prepend: true
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_staffer!
  before_action :opened_tickets_count, if: :staffer_signed_in?
  before_action :approved_admin_count, if: :staffer_signed_in?
  before_action :set_authorize

  layout 'admin'

  private

  def opened_tickets_count
    @opened_tickets_count ||= Ticket.opened.count
  end

  def approved_admin_count
    @approved_admin_count = ProposalEmployee.where(state: :paid, approved_by_admin: false).count
  end

  def pundit_user
    current_staffer
  end

  def set_authorize
    authorize [:admin, :staffer], :index?
  end

  def user_not_authorized
    render 'admin/staffers/user_not_authorized'
  end
end
