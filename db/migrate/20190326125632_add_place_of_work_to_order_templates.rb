class AddPlaceOfWorkToOrderTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :order_templates, :place_of_work, :text
  end
end
