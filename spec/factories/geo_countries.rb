FactoryBot.define do
  factory :geo_country, class: "Geo::Country" do
    name { Faker::Address.country }
  end
end
