FactoryBot.define do
  factory :message do
    text { Faker::Lorem.sentence }
  end

  factory :proposal_employee_disputed, class: 'Message' do
    text { Faker::Lorem.sentence }

    before(:create) do |msg|
      incident = create(:incident)
      msg.ticket = incident
      msg.sender = incident.user
      msg.sender_name = incident.user.full_name
    end
  end
end
