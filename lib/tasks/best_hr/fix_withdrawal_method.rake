namespace :best_hr do
  namespace :seed do
    desc 'Fix profiles data'
    task fix_withdrawal_method: :environment do
      p 'фиксим способ вывода'
      Profile.find_each do |p|
        next unless p.contractor?
        next if p.withdrawal_methods.count.positive?
        Cmd::Profile::Balance::WithdrawalMethod::Create.call(profile: p, legal_form: 'company')
        Cmd::Profile::Balance::WithdrawalMethod::Create.call(profile: p, legal_form: 'ip')
        Cmd::Profile::Balance::WithdrawalMethod::Create.call(profile: p, legal_form: 'private_person')
      end
    end
  end
end
