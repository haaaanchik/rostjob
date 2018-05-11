class CreateSpecializationReferences < ActiveRecord::Migration[5.2]
  def change
    create_table :specialization_references do |t|
      t.string :term

      t.timestamps
    end
    add_index :specialization_references, :term
  end
end
