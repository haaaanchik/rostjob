class Profile::TicketsController < ApplicationController
  include RolesHelper

  def index
    @appeal = Appeal.new
    @appeal.messages.build
    @paginated_tickets = tickets.includes(:user).page(params[:page])
  end

  def show
    @ticket = ticket.decorate
  end

  private

  def ticket_type
    params[:type]&.singularize || 'incident'
  end

  def ticket
    @ticket ||= all_tickets.find(params[:id])
  end

  def all_tickets
    Ticket.with_other_tickets_for(current_user)
  end

  def tickets
    params[:q][:waiting_not_eq] = profile_type if params[:q] && params[:q][:state_waiting_fields_eq] == 'opened'
    @q = Ticket.with_other_tickets_for(current_user).ransack(params[:q] || { state_cont:     'opened',
                                                                             waiting_not_eq: profile_type })
    @tickets ||= @q.result
  end
end
