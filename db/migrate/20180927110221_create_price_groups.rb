class CreatePriceGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :price_groups do |t|
      t.string :title
      t.integer :price

      t.timestamps
    end
  end
end
