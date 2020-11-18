# frozen_string_literal: true

class CheckInterviewDeadlineJob < ApplicationJob
  queue_as :critical

  def perform
    ProposalEmployee.interview.find_each(batch_size: 50) do |candidate|
      Cmd::ProposalEmployee::SendToDispute.call(candidate: candidate) if check_expiration_five_days(candidate)
    end
  end

  private

  def check_expiration_five_days(candidate)
    five_working_days = Holiday.plus_five_working_days(candidate.interview_date.to_date)
    Date.current >= five_working_days
  end
end
