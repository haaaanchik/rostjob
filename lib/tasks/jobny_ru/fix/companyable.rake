namespace :jobny_ru do
  namespace :fix do
    desc 'Fix companyable'
    task companyable: :environment do
      p 'фиксим полиморфную ассоциацию companyable'
      Company.find_each do |c|
        next if c.companyable_id
        c.companyable_id = c.profile_id
        c.companyable_type = 'Profile'
        c.save
      end
    end
  end
end
