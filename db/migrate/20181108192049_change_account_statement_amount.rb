class ChangeAccountStatementAmount < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      change_table :account_statements do |t|
        dir.up   { t.change :amount, :decimal, precision: 10, scale: 2 }
        dir.down { t.change :amount, :integer }
      end
    end
  end
end
