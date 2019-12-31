namespace :rostjob do
  namespace :seed do
    desc 'Creates clients: employer, recruiter.'
    task clients: :environment do
      Rake::Task['rostjob:seed:employer'].invoke
      # Rake::Task['rostjob:seed:recruiter'].invoke
      # Rake::Task['rostjob:seed:agency'].invoke
    end
  end
end
