class AddPublishedAtToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :published_at, :date

    Order.all.each do |order|
      order.update_attributes(published_at: order.created_at)
    end
  end
end
