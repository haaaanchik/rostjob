class SendingEveryDayMailContractorJob < ApplicationJob
  queue_as :critical

  def perform
    tomorrow_interview_contractor
    has_disputed_contractor
  end

  private

  def tomorrow_interview_contractor
    ProposalEmployee.interview.where(interview_date: (DateTime.now.beginning_of_day + 1.day))
      .group_by { |pr| pr.profile_id }.each do |_profile_id, prop_emp|
        ProposalEmployeeMailJob.perform_now(proposal_employees: prop_emp, method: 'tommorow_interview_contractor')
      end
  end

  def has_disputed_contractor
    Incident.opened.includes(:proposal_employee).group_by { |incident| incident.proposal_employee.profile_id }.each do |_profile_id, incident|
      SendNotifyMailJob.perform_now(objects: incident, method: 'informated_contractor_has_disputed')
    end
  end
end