namespace :jobny_ru do
  namespace :seed do
    desc 'Creates clients: employer, recruiter.'
    task clients: :environment do
      Rake::Task['jobny_ru:seed:employer'].invoke
      # Rake::Task['jobny_ru:seed:recruiter'].invoke
      # Rake::Task['jobny_ru:seed:agency'].invoke
    end
  end
end
