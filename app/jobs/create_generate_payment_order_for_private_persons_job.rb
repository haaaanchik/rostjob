class CreateGeneratePaymentOrderForPrivatePersonsJob < ApplicationJob
  queue_as :critical

  def perform
    Profile.contractors_private_persons.find_each(batch_size: 50) do |profile|
      balance = profile.balance
      amount = balance.amount
      next unless amount.positive?
      tax_calc = profile.tax_calculations.create! tax_base: amount
      balance.withdraw(tax_calc.tax_amount, 'Удержание НДФЛ')
      ::GeneratePaymentOrderJob.perform_later(profile, tax_calc.tax_base - tax_calc.tax_amount)
    end
  end
end
