class WithdrawalJob < ApplicationJob
  queue_as :processing

  def perform(withdrawal_method_id, amount)
    withdrawal_method = WithdrawalMethod.find(withdrawal_method_id)
    company = withdrawal_method.company
    profile = withdrawal_method.profile
    balance = profile.balance
    result = Cmd::Invoice::Create.call(profile: profile, company: company, amount: amount)
    return unless result.success?
    balance.withdraw(amount, 'Перевод вознаграждения исполнителю')
  end
end
