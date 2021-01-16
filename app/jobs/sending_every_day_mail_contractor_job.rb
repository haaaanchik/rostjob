class SendingEveryDayMailContractorJob < ApplicationJob
  queue_as :critical

  def perform
    tomorrow_interview_contractor
    has_disputed_contractor
  end

  private

  def tomorrow_interview_contractor
    ProposalEmployee.interview.includes(profile: :setting_objects).where(interview_date: (DateTime.now.beginning_of_day + 1.day))
      .group_by { |pr| pr.profile }.each do |profile, prop_emp|
        ProposalEmployeeMailJob.perform_now(proposal_employees: prop_emp, method: 'tommorow_interview_contractor') if profile.every_day_mailing?
      end
  end

  def has_disputed_contractor
    Incident.opened.where(waiting: 'customer').includes(:proposal_employee, user: { profile: :setting_objects }).group_by { |incident| incident.proposal_employee.profile }.each do |profile, incident|
      SendNotifyMailJob.perform_now(objects: incident, method: 'informated_contractor_has_disputed') if profile.every_day_mailing?
    end
  end
end