class CreateGeoRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :geo_regions do |t|
      t.string :name, index: true

      t.timestamps
    end

    add_reference :geo_regions, :country, index: true
    add_foreign_key :geo_regions, :geo_countries, column: :country_id
  end
end
