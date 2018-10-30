class CreateGeneratePaymentOrderForCompaniesJob < ApplicationJob
  queue_as :critical

  def perform
    Profile.contractors_companies.find_each(batch_size: 50) do |profile|
      next unless profile.balance.amount.positive?
      profile.balance.withdraw(amount, 'Перечисление вознаграждения исполнителю')
      ::GeneratePaymentOrderJob.perform_later(profile, profile.balance.amount)
    end
  end
end
