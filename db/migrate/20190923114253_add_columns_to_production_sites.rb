class AddColumnsToProductionSites < ActiveRecord::Migration[5.2]
  def change
    add_attachment :production_sites, :image
    add_column :production_sites, :city, :string
    add_column :production_sites, :info, :text
    add_column :production_sites, :phones, :text
  end
end
