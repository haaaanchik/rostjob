FactoryBot.define do
  factory :zero_balance, class: 'Balance' do
    factory :balance do
      after(:create) do |balance|
        balance.update_column(:amount, 1000000)
      end
    end
  end
end
