class SendMailJob < ApplicationJob
  queue_as :mail

  def perform(args)
    ContactUsMailer.with(message: args[:message], attrs: args[:attrs])
                   .public_send(args[:method])
                   .deliver
  end
end
