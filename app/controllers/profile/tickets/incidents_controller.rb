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

  def update
    ticket_waiting = incident.waiting
    result = Cmd::Ticket::Incident::Update.call(incident: incident, incident_params: incident_params)
    if result.success?
      create_message(params[:message]) if params[:message].present?
      flash[:notice] = flash_notice(ticket_waiting)
      redirect_to profile_ticket_path(result.incident)
    else
      render json: { validate: true, data: errors_data(result.incident) }, status: 422
    end
  end

  def hire
    hiring_date = Date.parse(params[:hiring_date])
    result = Cmd::ProposalEmployee::Hire.call(candidate: incident.proposal_employee,
                                              hiring_date: hiring_date)
    if result.success?
      create_message('Для анкеты назначена дата найма')
      incident.to_closed!
      redirect_to profile_ticket_path(incident)
    else
      render json: { validate: true, data: errors_data(result.candidate) }, status: 422
    end
  end

  def revoke
    result = Cmd::ProposalEmployee::Revoke.call(proposal_employee: incident.proposal_employee, log: true)
    if result.success?
      create_message('Анкета  отозвана!')
      redirect_to profile_ticket_path(incident)
    else
      @status = 'error'
    end
  end

  def inbox
    interview_date = Date.parse(params[:interview_date])
    result = Cmd::ProposalEmployee::ToInbox.call(candidate: incident.proposal_employee,
                                                 interview_date: interview_date,
                                                 log: true)
    if result.success?
      incident.to_closed!
      create_message('Анкета переведена в очередь')
      incident.update(waiting: params[:waiting]) if params[:waiting]
      redirect_to profile_ticket_path(incident)
    else
      render json: { validate: true, data: errors_data(result.candidate) }, status: 422
    end
  end

  def inteview
    interview_date = Date.parse(params[:interview_date])
    result = Cmd::ProposalEmployee::ToInterview.call(candidate: incident.proposal_employee,
                                                     interview_date: interview_date,
                                                     log: true)
    if result.success?
      create_message('Для анкеты назвачена дата собеседования.')
      incident.to_closed!
      redirect_to profile_ticket_path(incident)
    else
      render json: { validate: true, data: errors_data(result.candidate) }, status: 422
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
    params.require(:incident).permit(:title, :candidate_id, :proposal_employee_id, :waiting,
                                     messages_attributes: [:id, :text, :sender_name, :sender_id])
  end

  def create_message(message)
    text = { text: message }
    Cmd::Ticket::Message::Create.call(user: current_user, ticket: incident, message_params: text)
  end

  def flash_notice(ticket_waiting)
    'Тикет рассмотрит администрация сайта' if ticket_waiting == 'customer' && incident.waiting == 'contractor'
  end
end
