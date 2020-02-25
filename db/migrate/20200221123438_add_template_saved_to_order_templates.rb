class AddTemplateSavedToOrderTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :order_templates, :template_saved, :boolean, default: false

    OrderTemplate.all.update_all(template_saved: true)
  end
end
