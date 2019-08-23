class SendTransferMailJob < ApplicationJob
  queue_as :mail

  def perform(args)
    TransferMailer.with(candidate: args[:candidate]).send_notification.deliver
  end
end
