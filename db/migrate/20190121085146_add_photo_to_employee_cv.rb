class AddPhotoToEmployeeCv < ActiveRecord::Migration[5.2]
  def up
    add_attachment :employee_cvs, :photo
  end

  def down
    remove_attachment :employee_cvs, :photo
  end
end
