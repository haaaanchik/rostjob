class OrderMailJob < ApplicationJob
  queue_as :mail

  def perform(args)
    OrderMailer.with(order: args[:order], admin: args[:admin])
               .public_send(args[:method])
               .deliver_now
  end
end
