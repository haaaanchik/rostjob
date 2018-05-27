class AddNumberOfEmployeesDefaultToOrder < ActiveRecord::Migration[5.2]
  def change
    change_column_default :orders, :number_of_employees, 1
  end
end
