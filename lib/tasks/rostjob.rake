namespace :rostjob do
  namespace :seed do
    desc 'Populate database'
    task all: :environment do
      p 'Зполняем базу данными'
      Rake::Task['rostjob:seed:staff'].invoke
      Rake::Task['rostjob:seed:active_company'].invoke
      Rake::Task['rostjob:seed:city_reference'].invoke
      Rake::Task['rostjob:seed:init_invoice_number_seqs'].invoke
    end
  end
end
