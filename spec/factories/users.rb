FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    full_name { Faker::Name.name }
    guid { SecureRandom.uuid }
    password { Faker::Internet.password(min_length = 8, max_length = 10) }
    terms_of_service { true }
    password_changed_at { Time.now }
    password_digest { Faker::Internet.password(min_length = 8, max_length = 10) }

    factory :customer do
      association :profile, factory: [:customer_profile, :with_company]

      trait :new do
        password_digest { nil }
        password_changed_at { nil }
        association :profile, factory: [:customer_profile, :without_company]
      end

      trait :with_production_site do
        association :profile, factory: [:customer_profile, :with_profuction_site] 
      end

      trait :with_orders do
        association :profile, factory: [:customer_profile, :with_orders]
      end
    end

    trait :contractor do
      association :profile, factory: [:profile, :contractor_profile]
    end


    after(:build) do |u|
      u.skip_confirmation_notification!
      u.skip_confirmation!
    end

    after(:create) { |u| u.confirm }
  end
end
