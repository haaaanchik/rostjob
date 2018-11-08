class ChangeOrderMoneyFields < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      change_table :orders do |t|
        dir.up do
          t.change :customer_price, :decimal, precision: 10, scale: 2
          t.change :contractor_price, :decimal, precision: 10, scale: 2
          t.change :customer_total, :decimal, precision: 10, scale: 2
          t.change :contractor_total, :decimal, precision: 10, scale: 2
        end

        dir.down do
          t.change :customer_price, :integer
          t.change :contractor_price, :integer
          t.change :customer_total, :integer
          t.change :contractor_total, :integer
        end
      end
    end
  end
end
