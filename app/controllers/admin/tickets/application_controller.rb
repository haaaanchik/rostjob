class Admin::Tickets::ApplicationController < Admin::ApplicationController
  private

  def ticket
    @ticket ||= Ticket.find(params[:ticket_id])
  end
end
