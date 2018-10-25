class WarrantyPeriodProcessingJob < ApplicationJob
  queue_as :processing

  def perform(candidate)
    proposal = candidate.proposal
    profile = proposal.profile
    order = proposal.order
    amount = order.contractor_price
    profile.balance.deposit(amount, "Вознаграждение по заявке №#{order.id}")
  end
end
