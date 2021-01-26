class AddNumberContractToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :number_contract, :string
  end
end
