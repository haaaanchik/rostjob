FactoryBot.define do
  factory :profile do
    updated_by_self_at { Time.now }

    factory :customer_profile do
      profile_type { 'customer' }
      legal_form   { 'company' }

      trait :without_company do
        updated_by_self_at { nil }
      end

      trait :with_company do
        after(:create) { |prof| create(:company, companyable: prof) }
      end

      trait :with_profuction_site do
        after(:create) do |prof|
          create(:company, companyable: prof)
          create(:production_site, profile: prof)
        end
      end
    end

    trait :contractor_profile do
      profile_type { 'contractor' }
      legal_form   { 'private_person' }
    end

    after(:create) do |prof|
      create(:balance, profile: prof)
    end
  end
end
