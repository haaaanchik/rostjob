FactoryBot.define do
  factory :production_site do
    title { Faker::Company.name }
    info { 'body information text' }
    city { Faker::Address.city }
    phones { 795555555 }
  end
end