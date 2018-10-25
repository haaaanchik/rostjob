class RemoveProfileFromPaymentOrders < ActiveRecord::Migration[5.2]
  def change
    remove_reference :payment_orders, :profile, foreign_key: true
  end
end
