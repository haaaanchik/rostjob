class SendModerationMailJob < ApplicationJob
  queue_as :mail

  def perform(args)
    ModerationMailer.with(order: args[:order]).send_notification.deliver
  end
end
