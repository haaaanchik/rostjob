class CreateInvoiceNumberSeq < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_number_seqs do |t|
      t.integer :invoice_number
    end
  end
end
