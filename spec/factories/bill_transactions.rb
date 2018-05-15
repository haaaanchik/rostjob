FactoryBot.define do
  factory :bill_transaction do
    deposit 1
    withdrawal 1
    description "MyText"
    balance nil
  end
end
