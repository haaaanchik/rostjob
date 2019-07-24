class CreateOauths < ActiveRecord::Migration[5.2]
  def change
    create_table :oauths do |t|
      t.string :type
      t.string :code
      t.string :access_token
      t.string :refresh_token
      t.integer :ttl
      t.integer :expires_in
      t.string :token_type

      t.timestamps
    end
  end
end
