class CreateTaxOffices < ActiveRecord::Migration[5.2]
  def change
    create_table :tax_offices do |t|
      t.string :code
      t.string :payment_name
      t.string :inn
      t.string :kpp
      t.string :oktmo
      t.string :bank_name
      t.string :bank_bic
      t.string :bank_account
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
