FactoryBot.define do
  factory :account do
    account_number { '30101810122252000974' }
    corr_account { '30212810145250100374' }
    bic { '12345678' }
    bank { 'my bank name' }
    # company { nil }
    inn { '1650365000' }
    kpp { '165001001' }
    bank_address { 'Moscow city, Main str 2 app'}
    active { true }
  end
end
