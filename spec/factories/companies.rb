FactoryBot.define do
  factory :company do
    factory :customer_company do
      name { Faker::Company.name }
      short_name { Faker::Company.suffix }
      address { Faker::Address.street_address }
      mail_address { Faker::Internet.email }
      email { Faker::Internet.email }
      director { Faker::Name.name }
      own_company { true }
      legal_form { "company" }
      active { true }

      after(:create) do |company|
        create(:account, accountable: company)
      end
    end

    factory :contractor_company do
      name { Faker::Company.name }
      short_name { Faker::Company.suffix }
      address { Faker::Address.street_address }
      mail_address { Faker::Internet.email }
      email { Faker::Internet.email }
      director { Faker::Name.name }
      own_company { true }
      legal_form { "company" }
      active { true }
    end
  end
end