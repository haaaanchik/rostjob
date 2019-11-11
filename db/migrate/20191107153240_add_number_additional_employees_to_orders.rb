class AddNumberAdditionalEmployeesToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :number_additional_employees, :integer
  end
end
