class SendMailJob < ApplicationJob
  queue_as :mail

  def perform(args)
    ContactUsMailer.with(message: args[:message]).public_send(args[:method]).deliver
  end
end
