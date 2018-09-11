class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :account_number
      t.string :corr_account
      t.string :bic
      t.text :bank
      t.text :bank_address
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
