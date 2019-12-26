namespace :jobny_ru do
  namespace :fix do
    desc 'Destroy old orders up to yesterday'
    task destroy_old_orders: :environment do
      p 'Удаляем старые заявки с датой создания до вчера'
      old_orders = Order.where('created_at < ?', Time.current.yesterday.beginning_of_day)
      old_orders.each do |old_order|
        old_order.order_profiles.destroy_all
        old_order.proposals.destroy_all
        old_order.comments.destroy_all
        old_order.destroy
      end
    end
  end
end
