class AddPhoneNumberAltToEmployeeCv < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_cvs, :phone_number_alt, :string
  end
end
