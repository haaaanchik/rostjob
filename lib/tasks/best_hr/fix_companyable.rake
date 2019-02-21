namespace :best_hr do
  namespace :seed do
    desc 'Fix profiles data'
    task fix_companyable: :environment do
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
