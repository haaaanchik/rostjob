class AddOrderIdToEmployeeCv < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_cvs, :order_id, :integer
  end
end
