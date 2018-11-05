class AddStateToAccountStatement < ActiveRecord::Migration[5.2]
  def change
    add_column :account_statements, :state, :string
  end
end
