class AddAdvTextToOrderTemplate < ActiveRecord::Migration[5.2]
  def change
    add_column :order_templates, :adv_text, :text
  end
end
