class AddExperienceToEmployeeCv < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_cvs, :experience, :text
  end
end
