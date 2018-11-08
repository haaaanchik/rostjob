class ChangeTaxCalculationMoneyFields < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      change_table :tax_calculations do |t|
        dir.up do
          t.change :tax_base, :decimal, precision: 10, scale: 2
          t.change :tax_amount, :decimal, precision: 10, scale: 2
        end

        dir.down do
          t.change :tax_base, :integer
          t.change :tax_amount, :integer
        end
      end
    end
  end
end
