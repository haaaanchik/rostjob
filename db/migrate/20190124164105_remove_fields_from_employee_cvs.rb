class RemoveFieldsFromEmployeeCvs < ActiveRecord::Migration[5.2]
  def change
    remove_columns :employee_cvs, :warranty_date, :hiring_date, :firing_date
  end
end
