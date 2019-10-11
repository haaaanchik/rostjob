class AddPaymentDateToProposalEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :proposal_employees, :payment_date, :datetime

    ProposalEmployee.paid.each do |pe|
      pe.update(payment_date: pe.updated_at)
    end
  end
end
