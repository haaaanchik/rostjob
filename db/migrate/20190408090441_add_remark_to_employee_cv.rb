class AddRemarkToEmployeeCv < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_cvs, :remark, :text
  end
end
