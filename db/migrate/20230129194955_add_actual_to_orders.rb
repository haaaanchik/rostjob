class AddActualToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :actual, :boolean, default: :true, index: :true
  end
end
