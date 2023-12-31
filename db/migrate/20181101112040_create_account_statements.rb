class CreateAccountStatements < ActiveRecord::Migration[5.2]
  def change
    create_table :account_statements do |t|
      t.string :src_account
      t.date :date
      t.string :sender
      t.string :number
      t.integer :amount
      t.json :data
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
