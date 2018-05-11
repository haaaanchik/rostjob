class CreateCityReferences < ActiveRecord::Migration[5.2]
  def change
    create_table :city_references do |t|
      t.string :term

      t.timestamps
    end
    add_index :city_references, :term
  end
end
