FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    full_name { Faker::Name.name }
    guid { SecureRandom.uuid }
  end
end
