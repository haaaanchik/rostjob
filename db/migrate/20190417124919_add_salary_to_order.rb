class AddSalaryToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :salary, :text
  end
end
