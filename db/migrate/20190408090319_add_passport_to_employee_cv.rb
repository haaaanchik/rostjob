class AddPassportToEmployeeCv < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_cvs, :passport, :json
  end
end
