class AddLabelToCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :label, :string
  end
end
