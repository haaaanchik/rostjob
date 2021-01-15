class CreateApiKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :api_keys do |t|
      t.string :name,  null: false
      t.string :token, null: false, index: true
      t.string :access_ips
      t.string :state

      t.timestamps
    end
  end
end
