class AddEmployeeCvIdToUserActionLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :user_action_logs, :employee_cv_id, :integer
  end
end
