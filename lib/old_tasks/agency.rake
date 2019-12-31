namespace :rostjob do
  namespace :seed do
    desc 'Creates agency.'
    task agency: :environment do
      p 'Создаём агентство'
      email = 'agency@test.ru'
      profile_hash = {
        contact_person: Faker::Name.name,
        phone: Faker::PhoneNumber.phone_number,
        email: email,
        profile_type: 'agency',
        company_name: Faker::Company.name,
        city: Faker::Address.city
      }

      profile = Profile.create! profile_hash
      profile.photo = File.new "#{Rails.root}/public/img/default.png"
      profile.fill
      profile.save
      profile.create_balance

      User.create!(email: email, password: 'futyncndj', profile: profile,
                   last_sign_in_at: Time.now - 2.hours)
    end
  end
end
