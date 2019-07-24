class AddSuperJobIdToEmployeeCv < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_cvs, :super_job_id, :integer
  end
end
