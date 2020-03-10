class SendDirectMailJob < ApplicationJob
  queue_as :mail

  def perform(args)
    DirectMailMailer.with(user: args[:user], subject: args[:subject], message: args[:message])
      .public_send(args[:method]).deliver_now
  end
end