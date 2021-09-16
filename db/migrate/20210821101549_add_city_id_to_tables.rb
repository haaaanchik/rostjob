class AddCityIdToTables < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :city_id, :integer
    add_column :order_templates, :city_id, :integer
    add_column :production_sites, :city_id, :integer

    rename_column :orders, :city, :older_city
    rename_column :order_templates, :city, :older_city
    rename_column :production_sites, :city, :older_city

    add_index :orders, :city_id
    add_index :production_sites, :city_id
  end
end
