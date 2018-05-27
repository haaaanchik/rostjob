class AddFiringDateToEmployeeCv < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_cvs, :firing_date, :date
  end
end
