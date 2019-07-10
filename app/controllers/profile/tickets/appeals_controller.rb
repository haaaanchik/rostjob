class Profile::Tickets::AppealsController < ApplicationController
  def new
    appeal
  end

  def create
    result = Cmd::Ticket::Appeal::Create.call(user: current_user, appeal_params: appeal_params)
    render(json: { validate: true, data: errors_data(result.appeal) }, status: 422) && return unless result.success?
    redirect_to profile_tickets_path
  end

  private

  def appeal
    @appeal ||= Appeal.new
    @appeal.messages.build
  end

  def appeal_params
    params.require(:appeal).permit(:title, messages_attributes: [:text])
  end
end
