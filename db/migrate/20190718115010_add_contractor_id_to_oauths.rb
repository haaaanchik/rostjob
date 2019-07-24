class AddContractorIdToOauths < ActiveRecord::Migration[5.2]
  def change
    add_column :oauths, :contractor_id, :bigint
  end
end
