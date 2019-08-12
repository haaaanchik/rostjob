FactoryBot.define do
  factory :super_job_config, class: 'SuperJob::Config' do
    code { "MyString" }
    access_token { "MyString" }
    refresh_token { "MyString" }
    ttl { 1 }
    expires_in { 1 }
    token_type { "MyString" }
    contractor_id { "" }
  end
end
