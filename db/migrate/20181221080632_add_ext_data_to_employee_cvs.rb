class AddExtDataToEmployeeCvs < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_cvs, :ext_data, :json
    add_column :employee_cvs, :profile_id, :integer
  end
end
