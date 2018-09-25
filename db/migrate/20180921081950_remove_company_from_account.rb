class RemoveCompanyFromAccount < ActiveRecord::Migration[5.2]
  def change
    remove_reference :accounts, :company, foreign_key: true
  end
end
