FactoryBot.define do
  factory :order do
    title { "Title order" }
    city { Faker::Address.city }
    description { "tetx description" }
    commission { "MyString" }
    state { 'published' }
    skill { 'master' }
    contact_person { { name: Faker::Name.name, phone: '+79788888888' } }
    other_info { { remark: 'remart text', terms: 'add info' } }
    salary { '1222' }
    number_of_employees { '2' }
  end

  factory :created_order, parent: :order do
    before(:create) do |order|
      customer = create(:customer, :with_production_site)
      order.profile = customer.profile
      order.production_site = customer.profile.production_sites.last
      order.position = create(:price_group).positions.last
    end
  end
end
