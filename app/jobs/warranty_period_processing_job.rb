class WarrantyPeriodProcessingJob < ApplicationJob
  queue_as :processing

  def perform(candidate)
    Cmd::ProposalEmployee::Approval.call(candidate: candidate)
  end
end
