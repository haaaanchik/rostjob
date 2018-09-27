class AddPriceGroupToPosition < ActiveRecord::Migration[5.2]
  def change
    add_reference :positions, :price_group, foreign_key: true
  end
end
