FactoryBot.define do
  factory :incident do
    state { 'opened' }
    reason { 'other' }

    trait :not_come do
      title { 'not_come' }
    end

    trait :other do
      title { 'other' }
    end

    before(:create) do |inc|
      prop_empl = create(:proposal_employee, :disputed)
      user = prop_empl.order.profile.user
      inc.proposal_employee = prop_empl
      inc.user = user

      create(:message, ticket: inc,
        sender: user, sender_name: user.full_name)
    end
  end
end
