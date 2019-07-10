class Profile::Tickets::IncidentsController < ApplicationController
  def new
    new_incident
  end

  def show
    incident
  end

  def create
    result = Cmd::Ticket::Incident::Create.call(user: current_user, incident_params: incident_params.except(:candidate_id))
    if result.success?
      candidate = result.incident.proposal_employee
      candidate.to_disputed! if candidate.may_to_disputed?
      redirect_to profile_tickets_path
    else
      render json: { validate: true, data: errors_data(result.incident) }, status: 422
    end
  end

  private

  def incident
    @incident ||= Incident.find(params[:id])
  end

  def new_incident
    @new_incident ||= Incident.new(proposal_employee_id: params[:candidate_id])
    @new_incident.messages.build
  end

  def incident_params
    params.require(:incident).permit(:title, :candidate_id, :proposal_employee_id, messages_attributes: [:text])
  end
end
