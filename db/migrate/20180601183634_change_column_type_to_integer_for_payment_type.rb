class ChangeColumnTypeToIntegerForPaymentType < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :payment_type, :integer, default: 0
  end
end
