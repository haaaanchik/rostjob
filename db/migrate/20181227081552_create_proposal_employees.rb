class CreateProposalEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :proposal_employees do |t|

      t.belongs_to :proposal
      t.belongs_to :order
      t.belongs_to :profile
      t.belongs_to :employee_cv

      t.date :date_hired
      t.string :state
      t.json :marks

      t.timestamps
    end
  end
end
