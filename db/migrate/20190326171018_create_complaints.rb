class CreateComplaints < ActiveRecord::Migration[5.2]
  def change
    create_table :complaints do |t|
      t.string :state
      t.text :text
      t.references :proposal_employee, foreign_key: true
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
