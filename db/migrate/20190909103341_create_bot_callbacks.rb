class CreateBotCallbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :bot_callbacks do |t|
      t.bigint :candidate_id
      t.string :guid
      t.json :call_data

      t.timestamps
    end
  end
end
