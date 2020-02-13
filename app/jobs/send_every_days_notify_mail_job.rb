class SendEveryDaysNotifyMailJob < ApplicationJob
  queue_as :mail

  def perform(args)
    NotifyMailer.with(objects: args[:objects]).public_send(args[:method]).deliver_now
  end
end