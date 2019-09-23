class AddEmailToEmployeeCv < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_cvs, :email, :string
  end
end
