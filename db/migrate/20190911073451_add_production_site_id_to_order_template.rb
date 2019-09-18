class AddProductionSiteIdToOrderTemplate < ActiveRecord::Migration[5.2]
  def change
    add_reference :order_templates, :production_site, foreign_key: true
  end
end
