namespace :best_hr do
  namespace :seed do
    desc 'Fix profiles data'
    task fix_active_account: :environment do
      p 'фиксим активный аккаунт'
      Company.find_each do |c|
        next unless c.accounts.any?
          c.accounts.first.update_attribute(:active, true)
      end
    end
  end
end
