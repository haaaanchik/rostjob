FactoryBot.define do
  factory :account do
    account_number { '1234567' }
    corr_account { '12345678' }
    bic { '12345678' }
    bank { 'my bank name' }
    # company { nil }
    inn { '123456789' }
    kpp { '123456798' }
    bank_address { 'Moscow city, Main str 2 app'}
    active { true }
  end
end
