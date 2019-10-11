class AddProductionSiteIdToOrder < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :production_site, foreign_key: true
  end
end
