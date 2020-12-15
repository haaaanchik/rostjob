FactoryBot.define do
  factory :staffer do
    name { Faker::Name.name }
    login { Faker::Name.name }
    password { Faker::Internet.password(min_length = 8, max_length = 10) }

    trait :admin do
      after(:build) do |u|
        u.staffer_roles=(['admin'])
      end
    end

    trait :moderator do
      after(:build) do |u|
        u.staffer_roles=(['moderator'])
      end
    end
  end
end
