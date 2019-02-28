namespace :best_hr do
  namespace :fix do
    desc 'Fix company legal form'
    task company_legal_form: :environment do
      p 'фиксим правовую форму компании'
      Company.find_each do |c|
        if c.companyable.is_a? Profile
          c.legal_form = c.companyable.legal_form
          c.save
        end
      end
    end
  end
end
