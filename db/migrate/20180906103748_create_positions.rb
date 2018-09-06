class CreatePositions < ActiveRecord::Migration[5.2]
  def change
    create_table :positions do |t|
      t.string :title
      t.text :duties

      t.timestamps
    end
    add_index :positions, :title
  end
end
