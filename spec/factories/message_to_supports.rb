FactoryBot.define do
  factory :message_to_support do
    sender_name { "Ivan" }
    email_address { "to@example.org" }
    text { "Hello" }
  end
end
