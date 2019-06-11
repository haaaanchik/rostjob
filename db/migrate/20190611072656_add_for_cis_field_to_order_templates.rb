class AddForCisFieldToOrderTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :order_templates, :for_cis, :boolean
  end
end
