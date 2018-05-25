class CreatePositionReferences < ActiveRecord::Migration[5.2]
  def change
    create_table :position_references do |t|
      t.string :term
      t.text :duties

      t.timestamps
    end
    add_index :position_references, :term
  end
end
