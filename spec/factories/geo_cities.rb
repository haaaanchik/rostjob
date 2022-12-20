FactoryBot.define do
  factory :geo_city, class: "Geo::City" do
    association :region, factory: :geo_region

    name { Faker::Address.city }
  end
end
