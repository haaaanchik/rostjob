class AddCompletedAtToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :completed_at, :date

    Order.completed.each do |order|
      order.update_attributes(completed_at: order.updated_at)
    end
  end
end
