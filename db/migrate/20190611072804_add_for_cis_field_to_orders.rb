class AddForCisFieldToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :for_cis, :boolean
  end
end
