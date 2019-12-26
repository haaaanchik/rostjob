namespace :jobny_ru do
  namespace :seed do
    desc 'Populate database. All entities.'
    task all: :environment do
      p 'Зполняем базу данными'
      Rake::Task['jobny_ru:seed:clients'].invoke
      Rake::Task['jobny_ru:seed:staff'].invoke
      Rake::Task['jobny_ru:seed:references'].invoke
    end
  end
end
