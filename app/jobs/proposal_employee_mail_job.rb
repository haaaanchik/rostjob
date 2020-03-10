class ProposalEmployeeMailJob < ApplicationJob
  queue_as :mail

  def perform(args)
    NotifyMailer.with(proposal_employees: args[:proposal_employees]).public_send(args[:method]).deliver_now
  end
end