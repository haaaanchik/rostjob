class AddDocumentFieldToEmployeeCv < ActiveRecord::Migration[5.2]
  def up
    add_attachment :employee_cvs, :document
  end

  def down
    remove_attachment :employee_cvs, :document
  end
end
