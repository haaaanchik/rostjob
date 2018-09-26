class AddInnKppToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :inn, :string
    add_column :accounts, :kpp, :string
  end
end
