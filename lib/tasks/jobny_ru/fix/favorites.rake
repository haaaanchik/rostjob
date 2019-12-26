namespace :jobny_ru do
  namespace :fix do
    desc 'Fix favorites'
    task favorites: :environment do
      p 'Фиксим избранное'
      Favorite.find_by(id: 4)&.destroy
      Favorite.find_by(id: 5)&.destroy
      Favorite.find_by(favorable_id: 16)&.destroy
      Favorite.find_by(favorable_id: 17)&.destroy
      Favorite.find_by(favorable_id: 18)&.destroy
      Favorite.all.each do |f|
        OrderProfile.create! order_id: f.favorable_id, profile: f.user.profile
      end
    end
  end
end
