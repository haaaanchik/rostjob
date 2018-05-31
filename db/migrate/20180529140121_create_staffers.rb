class CreateStaffers < ActiveRecord::Migration[5.2]
  def change
    create_table :staffers do |t|
      t.string :name
      t.string :login
      t.string :password_digest
      t.string :guid

      t.timestamps
    end
  end
end
