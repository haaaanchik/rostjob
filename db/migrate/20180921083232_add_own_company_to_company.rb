class AddOwnCompanyToCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :own_company, :boolean, default: false
  end
end
