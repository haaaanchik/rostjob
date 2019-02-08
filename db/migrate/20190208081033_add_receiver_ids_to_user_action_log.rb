class AddReceiverIdsToUserActionLog < ActiveRecord::Migration[5.2]
  def change
    add_column :user_action_logs, :receiver_ids, :json
  end
end
