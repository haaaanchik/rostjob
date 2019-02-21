namespace :best_hr do
  namespace :seed do
    desc 'Fix profiles data'
    task fix_company_legal_form: :environment do
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
