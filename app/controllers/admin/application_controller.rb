class Admin::ApplicationController < BaseController
  include Admin::SessionsHelper

  protect_from_forgery prepend: true

  before_action :authenticate_staffer!
  before_action :opened_tickets_count, if: :staffer_signed_in?
  before_action :approved_admin_count, if: :staffer_signed_in?

  layout 'admin'

  private

  def opened_tickets_count
    @opened_tickets_count ||= Ticket.opened.count
  end

  def approved_admin_count
    @approved_admin_count = ProposalEmployee.approved_by_admin.count
  end
end
