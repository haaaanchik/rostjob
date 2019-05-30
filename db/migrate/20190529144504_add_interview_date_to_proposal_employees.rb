class AddInterviewDateToProposalEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :proposal_employees, :interview_date, :timestamp
  end
end
