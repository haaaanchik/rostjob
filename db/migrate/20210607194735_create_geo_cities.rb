class CreateGeoCities < ActiveRecord::Migration[5.2]
  def change
    create_table :geo_cities do |t|
      t.string :name, index: true
      t.string :synonym
      t.string :fias_code
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :long, precision: 10, scale: 6

      t.timestamps
    end

    add_reference :geo_cities, :region, index: true
    add_foreign_key :geo_cities, :geo_regions, column: :region_id
  end
end
