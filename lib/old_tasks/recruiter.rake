namespace :rostjob do
  namespace :seed do
    desc 'Creates recruiter.'
    task recruiter: :environment do
      p 'Создаём рекрутера'
      profile_type = 'recruiter'
      email = "recruiter@test.ru"
      profile_hash = {
        contact_person: Faker::Name.name,
        phone: Faker::PhoneNumber.phone_number,
        email: email,
        profile_type: profile_type,
        company_name: Faker::Company.name,
        description: Faker::Lorem.paragraph(2),
        city: Faker::Address.city
      }
      profile_hash[:company_name] = Faker::Company.name

      profile = Profile.create! profile_hash
      profile.photo = File.new "#{Rails.root}/public/img/default.png"
      profile.fill
      profile.save

      User.create!(email: email, password: 'htrhenth', profile: profile,
                   last_sign_in_at: Time.now - 2.hours)
    end
  end
end
