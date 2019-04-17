class AddSalaryToOrderTemplate < ActiveRecord::Migration[5.2]
  def change
    add_column :order_templates, :salary, :text
  end
end
