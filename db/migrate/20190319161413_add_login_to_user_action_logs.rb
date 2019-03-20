class AddLoginToUserActionLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :user_action_logs, :login, :string
  end
end
