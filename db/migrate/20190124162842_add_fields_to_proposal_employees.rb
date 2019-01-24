class AddFieldsToProposalEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :proposal_employees, :hiring_date, :date
    add_column :proposal_employees, :firing_date, :date
    add_column :proposal_employees, :warranty_date, :date
  end
end
