class AddWarrantyPeriodToPriceGroup < ActiveRecord::Migration[5.2]
  def change
    add_column :price_groups, :warranty_period, :integer, default: 10
  end
end
