class AddCompanyableToCompany < ActiveRecord::Migration[5.2]
  def change
    add_reference :companies, :companyable, polymorphic: true
  end
end
