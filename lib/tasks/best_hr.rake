namespace :best_hr do
  namespace :seed do
    desc 'Populate database. All entities.'
    task all: :environment do
      p 'Зполняем базу данными'
      Rake::Task['best_hr:seed:clients'].invoke
      Rake::Task['best_hr:seed:staff'].invoke
      Rake::Task['best_hr:seed:references'].invoke
    end
  end
end
