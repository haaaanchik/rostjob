class Profile::Tickets::IncidentsController < ApplicationController
  def new
    new_incident
  end

  def show
    incident
  end

  def create
    result = Cmd::Ticket::Incident::Create.call(user: current_user,
                                                incident_params: incident_params.except(:candidate_id))

    if result.success?
      redirect_to_after_create(result.incident.proposal_employee)
    else
      render json: { validate: true, data: errors_data(result.incident) }, status: 422
    end
  end

  def update
    ticket_waiting = incident.waiting
    result = Cmd::Ticket::Incident::Update.call(send_message_admin: params[:send_message_admin],
                                                incident: incident,
                                                ticket: incident,
                                                message_params: { text: message_text },
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

    do_after_action(result)
  end

  def revoke
    result = Cmd::Ticket::Inciden::Revoke.call(proposal_employee: incident.proposal_employee, 
                                               message_params: { text: 'Анкеты была отозвона' },
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

    do_after_action(result)
  end

  def interview
    message_text = current_profile.contractor? ? 'Для анкеты назначена дата приезда' : 'Для анкеты назначена дата собеседования.'
    result = Cmd::Ticket::Incident::Interview.call(candidate: incident.proposal_employee, user: current_user,
                                                    message_params: { text: message_text },
                                                    ticket: incident, interview_date: params[:interview_date],
                                                    incident: incident)

    do_after_action(result)
  end

  def failed_interview
    result = Cmd::Ticket::Incident::FailedInterview.call(message_params: { text: params[:incident][:messages_attributes]['0']['text'] },
                                                         proposal_employee: incident.proposal_employee,
                                                         user: current_user,
                                                         incident: incident,
                                                         ticket: incident)
    do_after_action(result)
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

  def do_after_action(result)
    if result.success?
      redirect_to profile_ticket_path(incident)
    else
      render json: { validate: true, data: errors_data(result.candidate) }, status: 422
    end
  end

  def message_text
    params[:message] || params[:incident][:messages_attributes]['0']['text']
  end
end
