class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.string :title

      t.timestamps
    end
    add_index :cities, :title
  end
end
