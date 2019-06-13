FactoryBot.define do
  factory :tax_office do
    code { 'MyString' }
    payment_name { 'MyString' }
    inn { 'MyString' }
    kpp { 'MyString' }
    oktmo { 'MyString' }
    bank_name { 'MyString' }
    bank_bic { 'MyString' }
    bank_account { 'MyString' }
    company { nil }
  end
end
