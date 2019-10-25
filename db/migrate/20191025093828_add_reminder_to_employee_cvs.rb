class AddReminderToEmployeeCvs < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_cvs, :reminder, :datetime
  end
end
