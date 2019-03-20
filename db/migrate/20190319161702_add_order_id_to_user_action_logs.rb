class AddOrderIdToUserActionLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :user_action_logs, :order_id, :integer
  end
end
