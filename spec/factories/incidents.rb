FactoryBot.define do
  factory :incident do
    state { 'opened' }
    title { 'not_come' }
    reason { 'other' }

    # after(:build) do |inc|
    #   create(:message, ticket: inc,
    #     sender: inc.user, sender_name: inc.user.full_name)
    # end

    before(:create) do |inc|
      prop_empl = create(:proposal_employee, :disputed)
      user = prop_empl.order.profile.user
      inc.proposal_employee = prop_empl
      inc.user = user

      # create(:message, ticket: inc,
      #   sender: user, sender_name: user.full_name)
    end
  end
end
