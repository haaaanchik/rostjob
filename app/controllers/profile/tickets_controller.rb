class Profile::TicketsController < ApplicationController
  def index
    paginated_tickets
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

  def paginated_tickets
    @paginated_tickets ||= tickets.page(params[:page])
  end

  def all_tickets
    Ticket.with_other_tickets_for(current_user)
  end

  def tickets
    @q = Ticket.with_other_tickets_for(current_user).ransack(params[:q] || { state_cont: 'opened' })
    @tickets ||= @q.result
  end
end
