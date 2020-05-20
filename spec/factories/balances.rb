FactoryBot.define do
  factory :zero_balance, class: 'Balance' do
    factory :balance do
      after(:create) do |balance|
        balance.deposit(1000000, 'Addd positive balance')
      end
    end
  end
end
