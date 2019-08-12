class CreateSuperJobConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :super_job_configs do |t|
      t.string :code
      t.string :access_token
      t.string :refresh_token
      t.integer :ttl
      t.integer :expires_in
      t.string :token_type
      t.bigint :contractor_id

      t.timestamps
    end
  end
end
