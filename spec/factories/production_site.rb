FactoryBot.define do
  factory :production_site_without_orders, class: 'ProductionSite' do
    title { Faker::Company.name }
    info { 'body information text' }
    association :city, factory: :geo_city
    phones { 795555555 }

    factory :production_site do
      order
      # association :orders, factory: :order
    end
  end
end