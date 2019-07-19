class AddAdvertisingToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :advertising, :boolean
  end
end
