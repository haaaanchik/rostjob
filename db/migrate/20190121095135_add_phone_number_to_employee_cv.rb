class AddPhoneNumberToEmployeeCv < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_cvs, :phone_number, :string
  end
end
