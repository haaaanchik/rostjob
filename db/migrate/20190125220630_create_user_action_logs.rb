class CreateUserActionLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :user_action_logs do |t|
      t.integer :receiver_id
      t.integer :subject_id
      t.string :subject_type
      t.string :subject_role
      t.text :action
      t.integer :object_id
      t.string :object_type

      t.timestamps
    end
  end
end
