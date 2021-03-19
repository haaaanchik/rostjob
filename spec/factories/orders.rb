FactoryBot.define do
  factory :order do
    city { Faker::Address.city }
    description { "tetx description" }
    state { 'published' }
    skill { 'master' }
    contact_person { { name: Faker::Name.name, phone: '+79788888888' } }
    other_info { { remark: 'remart text', terms: 'add info' } }
    salary { '1222' }
    number_of_employees { '2' }
    number_additional_employees { 0 }

    trait :draft do
      state { 'draft' }
    end

    trait :compleated do
      state { 'completed' }
    end

    trait :waiting_for_payment do
      state { 'waiting_for_payment' }
    end

    before(:create) do |order|
      customer = create(:customer, :with_production_site)
      order.profile = customer.profile
      order.production_site = customer.profile.production_sites.last

      price_group            = create(:price_group)
      order.position         = price_group.positions.last
      order.customer_price   = price_group.customer_price
      order.contractor_price = price_group.contractor_price
      order.customer_total   = (price_group.customer_price   * order.number_of_employees)
      order.contractor_total = (price_group.contractor_price * order.number_of_employees)
    end
  end
end
