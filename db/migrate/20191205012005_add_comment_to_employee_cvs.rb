class AddCommentToEmployeeCvs < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_cvs, :comment, :text
  end
end
