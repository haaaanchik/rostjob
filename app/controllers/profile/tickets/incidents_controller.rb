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
      redirect_to_after_create(candidate)
    else
      render json: { validate: true, data: errors_data(result.incident) }, status: 422
    end
  end

  def update
    ticket_waiting = incident.waiting
    result = Cmd::Ticket::Incident::Update.call(incident: incident,
                                                ticket: incident,
                                                message_params: { text: params[:message] },
                                                incident_params: incident_params,
                                                user: current_user,
                                                params: params)
    if result.success?
      flash[:notice] = flash_notice(ticket_waiting)
      redirect_to profile_ticket_path(result.incident)
    else
      render json: { validate: true, data: errors_data(result.incident) }, status: 422
    end
  end

  def hire
    result = Cmd::Ticket::Incident::Hire.call(candidate: incident.proposal_employee,
                                              message_params: { text: 'Для анкеты назначена дата найма.' },
                                              hiring_date: params[:hiring_date],
                                              incident: incident,
                                              ticket: incident,
                                              user: current_user,
                                              log: true)

    if result.success?
      redirect_to profile_ticket_path(incident)
    else
      render json: { validate: true, data: errors_data(result.candidate) }, status: 422
    end
  end

  def revoke
    result = Cmd::ProposalEmployee::Revoke.call(proposal_employee: incident.proposal_employee, 
                                                message_params: { text: 'Для анкеты назначена дата найма.' },
                                                incident: incident,
                                                ticket: incident,
                                                user: current_user)

    result.success? ? (redirect_to profile_ticket_path(incident)) : @status = 'error'
  end

  def inbox
    result = Cmd::Ticket::Incident::Inbox.call(candidate: incident.proposal_employee,
                                                message_params: { text: 'Анкета переведена в очередь.' },
                                                interview_date: params[:interview_date],
                                                incident: incident,
                                                ticket: incident,
                                                user: current_user,
                                                log: true)

    if result.success?
      redirect_to profile_ticket_path(incident)
    else
      render json: { validate: true, data: errors_data(result.candidate) }, status: 422
    end
  end

  def interview
    result = Cmd::Ticket::Incident::Interview.call(candidate: incident.proposal_employee, user: current_user,
                                                    message_params: { text: 'Для анкеты назвачена дата собеседования.' },
                                                    ticket: incident, interview_date: params[:interview_date],
                                                    incident: incident)

    if result.success?
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

  def redirect_to_after_create(candidate)
    if current_profile.customer?
      redirect_to profile_production_site_order_path(candidate.order.production_site, candidate.order_id)
    else
      redirect_to profile_tickets_path(q: { state_waiting_fields_eq: 'contractor' })
    end
  end
end
