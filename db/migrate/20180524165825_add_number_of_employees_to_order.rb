class AddNumberOfEmployeesToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :number_of_employees, :integer
  end
end
