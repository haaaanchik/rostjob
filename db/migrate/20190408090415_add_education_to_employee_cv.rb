class AddEducationToEmployeeCv < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_cvs, :education, :text
  end
end
