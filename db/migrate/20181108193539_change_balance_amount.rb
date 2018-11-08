class ChangeBalanceAmount < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      change_table :balances do |t|
        dir.up   { t.change :amount, :decimal, precision: 10, scale: 2 }
        dir.down { t.change :amount, :integer }
      end
    end
  end
end
