FactoryBot.define do
  factory :super_job_query, class: 'SuperJob::Query' do
    title { "MyString" }
    query_params { "" }
    active { false }
    super_job_config_id { nil }
  end
end
