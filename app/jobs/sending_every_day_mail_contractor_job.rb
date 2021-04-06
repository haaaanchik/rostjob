class SendingEveryDayMailContractorJob < ApplicationJob
  queue_as :critical

  def perform
    # tomorrow_interview_contractor
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
    ProposalEmployee.disputed.joins(:incidents).where(tickets: { waiting: 'customer' }).includes(:order, profile: :setting_objects).group_by { |pr| pr.order.profile }.each do |profile, prop_emp|
      next unless profile.every_day_mailing?

      ProposalEmployeeMailJob.perform_now(user: profile.user,
                                          proposal_employees: prop_emp,
                                          method: 'informated_user_has_disputed')
    end
  end
end