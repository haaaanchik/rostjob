class RemovePriceFromPriceGroup < ActiveRecord::Migration[5.2]
  def change
    remove_column :price_groups, :price, :integer
  end
end
