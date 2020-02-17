class SendingEveryDayMailContractorJob < ApplicationJob
  queue_as :critical
  def perform
    today_interview_contractor
    tomorrow_interview_contractor
  end

  private

  def today_interview_contractor
    ProposalEmployee.interview.where(interview_date: DateTime.now.beginning_of_day)
      .group_by { |pr| pr.profile_id }.each do |_profile_id, prop_emp|
        ProposalEmployeeMailJob.perform_now(proposal_employees: prop_emp, method: 'tommorow_interview_contractor')
      end
  end

  def tomorrow_interview_contractor
    ProposalEmployee.interview.where(interview_date: (DateTime.now.beginning_of_day + 1.day))
      .group_by { |pr| pr.profile_id }.each do |_profile_id, prop_emp|
        ProposalEmployeeMailJob.perform_now(proposal_employees: prop_emp, method: 'tommorow_interview_contractor')
      end
  end
end