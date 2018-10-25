class CreatePaymentOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_orders do |t|
      t.json :data
      t.string :state
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
