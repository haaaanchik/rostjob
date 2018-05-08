# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

COMPANIES = %w[employer agency].freeze

10.times do |t|
  profile_type = COMPANIES.sample
  email = "test_user#{t}@m.ru"
  profile_hash = {
    contact_person: Faker::Name.name,
    phone: Faker::PhoneNumber.phone_number,
    email: email,
    profile_type: profile_type,
    company_name: Faker::Company.name,
    city: Faker::Address.city
  }

  profile = Profile.create! profile_hash
  profile.photo = File.new "#{Rails.root}/public/img/default.jpg"
  profile.save

  User.create! email: email, password: "test_user#{t}12345678", profile: profile
end

10.upto 20 do |t|
  profile_type = 'recruiter'
  email = "test_user#{t}@m.ru"
  profile_hash = {
    contact_person: Faker::Name.name,
    phone: Faker::PhoneNumber.phone_number,
    email: email,
    profile_type: profile_type,
    company_name: Faker::Company.name,
    city: Faker::Address.city
  }
  profile_hash[:company_name] = Faker::Company.name

  profile = Profile.create! profile_hash
  profile.photo = File.new "#{Rails.root}/public/img/default.jpg"
  profile.save

  User.create! email: email, password: "test_user#{t}12345678", profile: profile
end

PROFESSIONS = ['Водитель погрузчика', 'Крановщик', 'Бухгалтер', 'Кассир',
               'Продавец - консультант'].freeze
Profile.all.each do |p|
  if COMPANIES.include? p.profile_type
    title = PROFESSIONS.sample
    salary_from = (10000..100000).to_a.sample
    5.times do |t|
      order_hash = {
        title: title,
        specialization: title,
        city: Faker::Address.city,
        salary_from: salary_from,
        salary_to: salary_from + 15000,
        description: Faker::Lorem.paragraph(2),
        commission: salary_from,
        warranty_period: (1..3).to_a.sample,
        number_of_recruiters: (1..5).to_a.sample,
        payment_type: %w[zero one two].sample,
        enterpreneurs_only: [true, false].sample,
        requirements_for_recruiters: Faker::Lorem.paragraph(2),
        stop_list: Faker::Lorem.paragraph(2),
        accepted: true
      }
      o = p.orders.create! order_hash
      o.update(created_at: Time.now - (0..30).to_a.sample.days)
      message = %i[publish! complete!].sample
      o.send message
    end
  end
end

executors = Profile.where.not(profile_type: 'employer')
Order.published.each do |o|
  current_profile = executors.sample
  proposal_hash = {
    description: Faker::Lorem.paragraph(2),
    order_id: o.id
  }
  proposal = current_profile.proposals.create! proposal_hash
  message = %i[accept! reject!].sample
  proposal.send message
end

3.times do
  Proposal.accepted.sample.complete!
end
