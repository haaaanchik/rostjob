class AddIndexToAccountStatements < ActiveRecord::Migration[5.2]
  def change
    add_index :account_statements, %i[number date src_account], unique: true
  end
end
