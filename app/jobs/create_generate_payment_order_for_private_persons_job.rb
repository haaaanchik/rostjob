class CreateGeneratePaymentOrderForPrivatePersonsJob < ApplicationJob
  queue_as :critical

  def perform
    Profile.contractors_private_persons.find_each(batch_size: 50) do |profile|
      balance = profile.balance
      amount = balance.amount
      next unless amount.positive?
      tax_calculation = profile.tax_calculations.create! tax_base: amount
      tax_base = tax_calculation.tax_base
      tax_amount = tax_calculation.tax_amount
      reward = tax_base - tax_amount
      balance.withdraw(tax_amount, 'Удержание НДФЛ')
      balance.withdraw(reward, 'Перечисление вознаграждения исполнителю')
      ::GeneratePaymentOrderJob.perform_later(profile, reward)
    end
  end
end
