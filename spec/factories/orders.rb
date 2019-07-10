FactoryBot.define do
  factory :order do
    title { "MyString" }
    specialization { "MyText" }
    city { "MyString" }
    description { "MyText" }
    commission { "MyString" }
    payment_type { "MyString" }
    number_of_recruiters { 1 }
    enterpreneurs_only { false }
    accepted { false }
    visibility { "MyString" }
    state { "MyString" }
    profile { nil }
    experience { 'adf' }
    schedule { 'adf' }
    salary { 'afd' }
    work_period { 'afd' }
    place_of_work { 'adf' }
  end
end
