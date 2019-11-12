class OrderMailJob < ApplicationJob
  queue_as :mail

  def perform(args)
    OrderMailer.with(order: args[:order]).public_send(args[:method]).deliver
  end
end
