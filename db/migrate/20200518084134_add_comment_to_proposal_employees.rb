class AddCommentToProposalEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :proposal_employees, :comment, :text
  end
end
