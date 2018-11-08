class ChangeBillTransactionAmount < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      change_table :bill_transactions do |t|
        dir.up   { t.change :amount, :decimal, precision: 10, scale: 2 }
        dir.down { t.change :amount, :integer }
      end
    end
  end
end
