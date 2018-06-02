namespace :best_hr do
  namespace :seed do
    desc 'Creates staff: admin, moderator.'
    task staff: :environment do
      Rake::Task['best_hr:seed:admin'].invoke
      Rake::Task['best_hr:seed:moderator'].invoke
    end
  end
end
