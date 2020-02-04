class AddAdminApprovalToProposalEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :proposal_employees, :approved_by_admin, :boolean, default: false

    ProposalEmployee.paid.update_all(approved_by_admin: true)
  end
end
