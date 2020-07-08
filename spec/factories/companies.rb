FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    short_name { Faker::Company.suffix }
    address { Faker::Address.street_address }
    mail_address { Faker::Internet.email }
    phone { '+7(960)-067-53-47' }
    fax { '+7(960)-067-53-47' }
    email { Faker::Internet.email }
    inn { 'РОСТ' }
    kpp { 'РОСТ' }
    ogrn { 'РОСТ' }
    director { Faker::Name.name }
    acts_on { 'РОСТ' }
    own_company { true }
    legal_form { "company" }
    active { true }

    after(:create) do |company|
      create(:account, accountable: company)
    end
  end
end