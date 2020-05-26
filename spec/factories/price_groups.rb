FactoryBot.define do
  factory :price_group do
    sequence :title do |n|
      "price_group#{n}"
    end

    customer_price { rand(1000..10000) }
    contractor_price { (customer_price - 500) }

    after(:create) { |p_g| create(:position, price_group: p_g) }
  end
end
