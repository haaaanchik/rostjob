class AddHiringDateToEmployeeCv < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_cvs, :hiring_date, :date
  end
end
