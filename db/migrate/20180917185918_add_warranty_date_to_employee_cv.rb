class AddWarrantyDateToEmployeeCv < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_cvs, :warranty_date, :date
  end
end
