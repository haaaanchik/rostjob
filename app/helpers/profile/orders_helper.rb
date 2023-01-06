module Profile::OrdersHelper
  def orders_state_attributtes_for_select
    [['Все статусы',''],
      ['Ожидает оплаты', 'waiting_for_payment'],
      ['На модерации', 'moderation'],
      ['Открыта', 'published'],
      ['Отклонена', 'rejected'],
      ['Закрыта', 'completed']]
  end

  def orders_cities_for_select
    cities = [['Любой город', '']]
    cities_ids_w_orders = Order.where(state: :published).pluck(:city_id).reject(&:nil?).sort.uniq
    Geo::City.order(name: :asc).where(id: cities_ids_w_orders).each do |city|
      cities << [city.name, city.id]
    end
    cities
  end
end
