namespace :jobny_ru do
  namespace :fix do
    desc 'Fix active account'
    task active_account: :environment do
      p 'фиксим активный аккаунт'
      Company.find_each do |c|
        next unless c.accounts.any?
        c.accounts.first.update_attribute(:active, true)
      end
    end
  end
end
