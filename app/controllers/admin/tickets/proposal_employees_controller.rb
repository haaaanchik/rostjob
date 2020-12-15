class Admin::Tickets::ProposalEmployeesController < Admin::Tickets::ApplicationController
  def revoke
    result =  Cmd::Ticket::Incident::Revoke.call(proposal_employee: proposal_employee,
                                                message_params: { text: 'Анкеты была отозвона, администрацией.' },
                                                user: current_staffer.decorate,
                                                incident: ticket,
                                                ticket: ticket)

    redirect_to admin_tickets_path if result.success?
  end

  def hire
    result = Cmd::Ticket::Incident::Hire.call(message_params: { text: 'Для анкеты назначена дата найма, администратором.' },
                                              hiring_date: candidate_params[:hiring_date],
                                              candidate: proposal_employee,
                                              user: current_staffer.decorate,
                                              incident: ticket,
                                              ticket: ticket)

    redirect_to admin_tickets_path if result.success?
  end

  def to_interview
    result = Cmd::Admin::Ticket::Incident::Interview.call(message_params: { text: 'Для анкеты назначена дата приезда, администратором.' },
                                                          interview_date: candidate_params[:interview_date],
                                                          proposal_employee: proposal_employee,
                                                          user: current_staffer.decorate,
                                                          incident: ticket,
                                                          ticket: ticket)

    redirect_to admin_tickets_path if result.success?
  end

  private

  def candidate_params
    params.required(:proposal_employee).permit(:interview_date, :hiring_date)
  end

  def proposal_employee
    @proposal_employee ||= ProposalEmployee.find(params[:id])
  end
end
