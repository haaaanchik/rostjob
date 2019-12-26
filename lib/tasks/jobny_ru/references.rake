namespace :jobny_ru do
  namespace :seed do
    desc 'Creates references: sities, positions, specializations.'
    task references: :environment do
      Rake::Task['jobny_ru:seed:position_reference'].invoke
      Rake::Task['jobny_ru:seed:specialization_reference'].invoke
      Rake::Task['jobny_ru:seed:city_reference'].invoke
      Rake::Task['jobny_ru:seed:production_calendar'].invoke
    end
  end
end
