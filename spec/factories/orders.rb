FactoryBot.define do
  factory :order do
    title { "Title order" }
    city { Faker::Address.city }
    description { "tetx description" }
    commission { "MyString" }
    state { 'published' }
    skill { 'master' }
    contact_person { { contact_name: Faker::Name.name, contact_phone: '7978888888' } }
    other_info { { remark: 'remart text', terms: 'add info' }}
    salary { '1222' }
    number_of_employees { '1' }
  end
end
