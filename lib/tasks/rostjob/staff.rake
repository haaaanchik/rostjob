namespace :rostjob do
  namespace :seed do
    desc 'Creates staff: admin, moderator.'
    task staff: :environment do
      Rake::Task['rostjob:seed:admin'].invoke
      Rake::Task['rostjob:seed:moderator'].invoke
    end
  end
end
