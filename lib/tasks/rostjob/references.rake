namespace :rostjob do
  namespace :seed do
    desc 'Creates references: sities, positions, specializations.'
    task references: :environment do
      Rake::Task['rostjob:seed:position_reference'].invoke
      Rake::Task['rostjob:seed:specialization_reference'].invoke
      Rake::Task['rostjob:seed:city_reference'].invoke
      Rake::Task['rostjob:seed:production_calendar'].invoke
    end
  end
end
