namespace :rostjob do
  namespace :seed do
    desc 'Populate database. All entities.'
    task all: :environment do
      p 'Зполняем базу данными'
      Rake::Task['rostjob:seed:clients'].invoke
      Rake::Task['rostjob:seed:staff'].invoke
      Rake::Task['rostjob:seed:references'].invoke
    end
  end
end
