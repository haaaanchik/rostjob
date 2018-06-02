namespace :best_hr do
  namespace :seed do
    desc 'Creates clients: employer, recruiter.'
    task clients: :environment do
      Rake::Task['best_hr:seed:employer'].invoke
      Rake::Task['best_hr:seed:recruiter'].invoke
    end
  end
end
