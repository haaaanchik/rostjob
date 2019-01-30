class AddBasePricesToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :base_customer_price, :integer
    add_column :orders, :base_contractor_price, :integer
  end
end
