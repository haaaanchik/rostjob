FactoryBot.define do
  factory :account do
    account_number { 'MyString' }
    corr_account { 'MyString' }
    bic { 'MyString' }
    bank { 'MyText' }
    company { nil }
  end
end
