class CreateEmployeeCvs < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_cvs do |t|
      t.string :name
      t.string :gender
      t.date :birthdate
      t.references :proposal, foreign_key: true
      t.attachment :file

      t.timestamps
    end
  end
end
