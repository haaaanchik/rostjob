class AddAdvTextToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :adv_text, :text
  end
end
