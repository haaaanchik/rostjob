class WarrantyPeriodProcessingJob < ApplicationJob
  queue_as :processing

  def perform(candidate)
    Cmd::ProposalEmployee::Pay.call(candidate: candidate)
  end
end
