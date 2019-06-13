FactoryBot.define do
  factory :employee_cv do
    name { "MyString" }
    gender { "MyString" }
    birthdate { "2018-05-03" }
    proposal { nil }
    file { "" }
  end
end
