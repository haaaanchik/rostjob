class CreateProductionSites < ActiveRecord::Migration[5.2]
  def change
    create_table :production_sites do |t|
      t.text :title
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
