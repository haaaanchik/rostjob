class CreateMessageToSupports < ActiveRecord::Migration[5.2]
  def change
    create_table :message_to_supports do |t|
      t.string :sender_name
      t.string :email_address
      t.text :text

      t.timestamps
    end
  end
end
