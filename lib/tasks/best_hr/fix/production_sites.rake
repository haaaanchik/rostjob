namespace :best_hr do
  namespace :fix do
    desc 'Fix production sites'
    task production_sites: :environment do
      p 'фиксим дефолтную производственную площадку'
      profile_ids = Order.pluck(:profile_id).uniq
      profile_ids.each do |pid|
        default_prod_site = Profile.find(pid).production_sites.create(title: 'Дефолтная площадка')
        Order.where(profile_id: pid).update_all(production_site_id: default_prod_site.id)
        OrderTemplate.where(profile_id: pid).update_all(production_site_id: default_prod_site.id)
      end
    end
  end
end
