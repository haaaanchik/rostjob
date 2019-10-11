class AddInvoiceIdToBillTransactions < ActiveRecord::Migration[5.2]
  def change
    add_reference :bill_transactions, :invoice

    bill_transactions = BillTransaction.where(description:      'Перевод вознаграждения исполнителю',
                                              transaction_type: 'withdrawal')
    bill_transactions.each do |bt|
      profile = bt.balance.profile
      invoice = profile.invoices.where('created_at <= ?', bt.created_at).order(id: :desc).limit(1).first
      bt.update_attribute(:invoice_id, invoice.id)
    end
  end
end
