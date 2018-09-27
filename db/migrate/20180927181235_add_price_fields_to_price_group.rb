class AddPriceFieldsToPriceGroup < ActiveRecord::Migration[5.2]
  def change
    add_column :price_groups, :customer_price, :integer
    add_column :price_groups, :contractor_price, :integer
  end
end
