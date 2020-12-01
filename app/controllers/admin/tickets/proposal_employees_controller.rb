class Admin::Tickets::ProposalEmployeesController < Admin::Tickets::ApplicationController
  def revoke
    result =  Cmd::Ticket::Inciden::Revoke.call(proposal_employee: proposal_employee,
                                                message_params: { text: 'Анкеты была отозвона, администрацией' },                                       
                                                user: current_staffer,
                                                incident: ticket,
                                                ticket: ticket)
    redirect_to admin_tickets_path if result.success?
  end

  def hire
    result = Cmd::ProposalEmployee::Hire.call(candidate: proposal_employee,
                                              hiring_date: candidate_params[:hiring_date])
    if result.success?
      ticket.to_closed!
      redirect_to admin_tickets_path
    else
      render json: { validate: true, data: errors_data(result.candidate) }, status: 422
    end
  end

  def to_inbox
    result = Cmd::ProposalEmployee::ToInbox.call(candidate: proposal_employee,
                                                 interview_date: candidate_params[:interview_date])
    if result.success?
      ticket.to_closed!
      redirect_to admin_tickets_path
    else
      render json: { validate: true, data: errors_data(result.candidate) }, status: 422
    end
  end

  private

  def candidate_params
    params.required(:proposal_employee).permit(:interview_date, :hiring_date)
  end

  def proposal_employee
    @proposal_employee ||= ProposalEmployee.find(params[:id])
  end
end
