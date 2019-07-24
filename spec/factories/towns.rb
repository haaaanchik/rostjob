FactoryBot.define do
  factory :town do
    id_region { 1 }
    id_country { 1 }
    title { "MyString" }
    title_eng { "MyString" }
    super_job_id { 1 }
  end
end
