FactoryBot.define do
  factory :geo_region, class: "Geo::Region" do
    association :country, factory: :geo_country

    name { Faker::Address.state }
  end
end
