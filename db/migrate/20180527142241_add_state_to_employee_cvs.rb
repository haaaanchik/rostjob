class AddStateToEmployeeCvs < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_cvs, :state, :string
  end
end
