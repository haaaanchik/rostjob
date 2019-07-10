FactoryBot.define do
  factory :ticket do
    user { nil }
    type { "" }
    state { "MyString" }
    proposal_employee_id { "" }
    title { "MyText" }
  end
end
