class GeneratePaymentOrderJob < ApplicationJob
  queue_as :payment_orders

  def perform(profile, amount)
    Cmd::PaymentOrder::Create.call(profile: profile, amount: amount)
  end
end
