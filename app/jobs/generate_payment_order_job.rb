class GeneratePaymentOrderJob < ApplicationJob
  queue_as :payment_orders

  def perform(profile, amount)
    result = Cmd::PaymentOrder::Create.call(profile: profile, amount: amount)
    profile.balance.withdraw(amount, 'Перечисление вознаграждения исполнителю') if result.success?
  end
end
