class AddColumnToPositions < ActiveRecord::Migration[5.2]
  def change
    add_column :positions, :description, :text
    add_column :positions, :landing_title, :string
    add_column :positions, :slug, :string

    add_index :positions, :slug, unique: true
  end
end
