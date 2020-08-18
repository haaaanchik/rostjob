class Admin::TicketsController < Admin::ApplicationController
  def index
    paginated_tickets
  end

  def show
    @ticket = ticket.decorate
  end

  def close
    result = Cmd::Admin::Ticket::Close.call(ticket: ticket)
    redirect_to admin_tickets_path if result.success?
  end

  private

  def ticket
    @ticket ||= Ticket.find(params[:id])
  end

  def paginated_tickets
    @paginated_tickets ||= tickets.includes(:user).page(params[:page])
  end

  def tickets
    @q = Ticket.ransack(params[:q] || { state_cont: 'opened' })
    @tickets ||= @q.result
  end
end
