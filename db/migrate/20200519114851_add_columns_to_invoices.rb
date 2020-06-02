class AddColumnsToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :checking_pay, :boolean, default: false, after: :state
    add_column :invoices, :tinkoff_pdf_url, :string, after: :checking_pay
    add_column :invoices, :error_message, :string, after: :tinkoff_pdf_url
  end
end
