class AddLegalFormToCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :legal_form, :string
  end
end
