class AddWarrantyPeriodToPositions < ActiveRecord::Migration[5.2]
  def change
    add_column :positions, :warranty_period, :integer, default: 10

    remove_columns :orders,          :warranty_period, :title
    remove_columns :order_templates, :warranty_period, :title
  end
end
