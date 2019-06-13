FactoryBot.define do
  factory :order do
    title { "MyString" }
    specialization { "MyText" }
    sity { "MyString" }
    salary_from { 1 }
    salary_to { 1 }
    description { "MyText" }
    commission { "MyString" }
    payment_type { "MyString" }
    number_of_recruiters { 1 }
    enterpreneurs_only { false }
    requirements_for_recruiters { "MyText" }
    stop_list { "MyText" }
    accepted { false }
    visibility { "MyString" }
    state { "MyString" }
    profile { nil }
  end
end
