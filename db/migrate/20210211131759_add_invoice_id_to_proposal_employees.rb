class AddInvoiceIdToProposalEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :proposal_employees, :invoice_id, :integer

    Invoice.joins(:profile).where(profiles: { profile_type: 'contractor' }).order(created_at: :desc).each do |invoice|
      prev_invoice = Invoice.where('created_at < ?', invoice.created_at)
                            .where(profile_id: invoice.profile_id)
                            .order(id: :desc).limit(1).first

      if !prev_invoice
        ProposalEmployee.approved_by_admin
                        .where(profile_id: invoice.profile_id)
                        .update_all(invoice_id: invoice.id)
      else
        ProposalEmployee.approved_by_admin
                        .paid_employees_during(invoice.profile_id, invoice.created_at, prev_invoice.created_at)
                        .update_all(invoice_id: invoice.id)
      end
    end
  end
end
