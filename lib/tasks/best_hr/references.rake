namespace :best_hr do
  namespace :seed do
    desc 'Creates references: sities, positions, specializations.'
    task references: :environment do
      Rake::Task['best_hr:seed:position_reference'].invoke
      Rake::Task['best_hr:seed:specialization_reference'].invoke
      Rake::Task['best_hr:seed:city_reference'].invoke
    end
  end
end
