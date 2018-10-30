class AddTotalFieldsToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :customer_total, :integer, default: 0
    add_column :orders, :contractor_total, :integer, default: 0
  end
end
