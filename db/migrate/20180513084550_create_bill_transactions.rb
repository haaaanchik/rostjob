class CreateBillTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :bill_transactions do |t|
      t.integer :amount, default: 0
      t.text :description
      t.string :transaction_type
      t.references :balance, foreign_key: true

      t.timestamps
    end
  end
end
