class AddArrivalDateToProposalEmployee < ActiveRecord::Migration[5.2]
  def change
    add_column :proposal_employees, :arrival_date, :date
  end
end
