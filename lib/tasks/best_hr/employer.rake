namespace :best_hr do
  namespace :seed do
    desc 'Creates employer.'
    task employer: :environment do
      p 'Создаём работодателя'
      email = 'employer@test.ru'
      name = Faker::Name.name
      profile_hash = {
        contact_person: name,
        phone: Faker::PhoneNumber.phone_number,
        email: email,
        profile_type: 'contractor',
        company_name: Faker::Company.name,
        city: Faker::Address.city
      }

      profile = Profile.create! profile_hash
      profile.photo = File.new "#{Rails.root}/public/img/default.png"
      profile.fill
      profile.save
      profile.create_balance

      User.create!(email: email, password_confirmation: 'hf,jnjlfntkm',
                   password: 'hf,jnjlfntkm', profile: profile,
                   full_name: name, last_sign_in_at: Time.now - 2.hours)
    end
  end
end
