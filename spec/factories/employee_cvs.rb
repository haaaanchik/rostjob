FactoryBot.define do
  factory :employee_cv do
    name { Faker::Name.name }
    phone_number { '+7(955)-555-55-55"' }
    gender { 'М' }
    education { 'hight shool name of ' }
    experience { 'more 1 year in managment' }
    remark { 'add inforation has not got' }
    comment { 'norify message for contractor' }
  end
end
