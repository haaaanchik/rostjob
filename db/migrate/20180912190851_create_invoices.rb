class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.string :invoice_number
      t.integer :amount
      t.json :seller
      t.json :buyer
      t.json :goods
      t.string :state
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
