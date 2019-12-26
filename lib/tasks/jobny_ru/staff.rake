namespace :jobny_ru do
  namespace :seed do
    desc 'Creates staff: admin, moderator.'
    task staff: :environment do
      Rake::Task['jobny_ru:seed:admin'].invoke
      Rake::Task['jobny_ru:seed:moderator'].invoke
    end
  end
end
