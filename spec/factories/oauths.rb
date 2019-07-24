FactoryBot.define do
  factory :oauth do
    type { "" }
    code { "MyString" }
    access_token { "MyString" }
    refresh_token { "MyString" }
    ttl { 1 }
    expires_in { 1 }
    token_type { "MyString" }
  end
end
