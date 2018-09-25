class AddProfileToCompany < ActiveRecord::Migration[5.2]
  def change
    add_reference :companies, :profile, foreign_key: true
  end
end
