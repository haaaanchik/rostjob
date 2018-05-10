class CreateProfessionReferences < ActiveRecord::Migration[5.2]
  def change
    create_table :profession_references do |t|
      t.string :term

      t.timestamps
    end
    add_index :profession_references, :term
  end
end
