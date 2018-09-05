class SendMailJob < ApplicationJob
  queue_as :mail

  def perform(args)
    ContactUsMailer.with(message: args[:message]).send_notification.deliver
  end
end
