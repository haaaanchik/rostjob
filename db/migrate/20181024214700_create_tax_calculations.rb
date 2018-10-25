class CreateTaxCalculations < ActiveRecord::Migration[5.2]
  def change
    create_table :tax_calculations do |t|
      t.integer :tax_base
      t.integer :tax_amount
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
