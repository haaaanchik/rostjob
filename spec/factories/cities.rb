FactoryBot.define do
  factory :city do
    title { Faker::Address.city }
  end
end
