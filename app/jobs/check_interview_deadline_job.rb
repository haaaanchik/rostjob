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
    (Date.current - 5.days) > candidate.interview_date
  end
end
