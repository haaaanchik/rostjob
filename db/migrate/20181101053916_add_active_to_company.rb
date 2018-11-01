class AddActiveToCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :active, :boolean, default: false
  end
end
