class CreateGeoCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :geo_countries do |t|
      t.string :name, index: true

      t.timestamps
    end
  end
end
