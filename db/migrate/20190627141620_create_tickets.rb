class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.references :user, foreign_key: true
      t.string :type
      t.string :state
      t.bigint :proposal_employee_id
      t.text :title

      t.timestamps
    end
  end
end
