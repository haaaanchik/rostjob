class AddAdvertisingToOrderTemplate < ActiveRecord::Migration[5.2]
  def change
    add_column :order_templates, :advertising, :boolean
  end
end
