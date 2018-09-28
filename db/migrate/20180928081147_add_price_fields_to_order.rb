class AddPriceFieldsToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :customer_price, :integer
    add_column :orders, :contractor_price, :integer
  end
end
