class Admin::Tickets::ProposalEmployeesController < Admin::Tickets::ApplicationController
  def revoke
    result = Cmd::Ticket::Incident::Revoke.call(proposal_employee: proposal_employee,
                                                message_params: { text: 'Анкеты была отозвона, администрацией.' },
                                                user: current_staffer.decorate,
                                                incident: ticket,
                                                ticket: ticket)

    do_after_update(result, "Анкета, #{result.proposal_employee.employee_cv.name} отозвана")
  end

  def hire
    result = Cmd::Admin::Ticket::Incident::Hire.call(message_params: { text: 'Для анкеты назначена дата найма, администратором.' },
                                                     hiring_date: candidate_params[:hiring_date],
                                                     order: proposal_employee.order,
                                                     user: current_staffer.decorate,
                                                     candidate: proposal_employee,
                                                     incident: ticket,
                                                     ticket: ticket)

    do_after_update(result, "#{result.candidate.employee_cv.name} нанят")
  end

  def to_interview
    result = Cmd::Admin::Ticket::Incident::Interview.call(message_params: { text: 'Для анкеты назначена дата приезда, администратором.' },
                                                          interview_date: candidate_params[:interview_date],
                                                          proposal_employee: proposal_employee,
                                                          user: current_staffer.decorate,
                                                          incident: ticket,
                                                          ticket: ticket)

    do_after_update(result, "Назчаненна дата интервью для #{result.proposal_employee.employee_cv.name}")
  end

  private

  def candidate_params
    params.required(:proposal_employee).permit(:interview_date, :hiring_date)
  end

  def proposal_employee
    @proposal_employee ||= ProposalEmployee.find(params[:id])
  end

  def do_after_update(result, success_message)
    if result.success?
      redirect_to admin_tickets_path, notice: success_message
    else
      redirect_to admin_ticket_path(ticket), alert: result.errors
    end
  end
end
