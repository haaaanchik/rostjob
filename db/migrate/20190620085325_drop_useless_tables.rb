class DropUselessTables < ActiveRecord::Migration[5.2]
  def up
    if table_exists?(:city_references)
      remove_index :city_references, :title if index_exists?(:city_references, :title)
      drop_table 'city_references'
    end
    if table_exists?(:position_references)
      remove_index :position_references, :title if index_exists?(:position_references, :title)
      drop_table 'position_references'
    end
    if table_exists?(:specialization_references)
      remove_index :specialization_references, :title if index_exists?(:specialization_references, :title)
      drop_table 'specialization_references'
    end
  end

  def down
    create_table 'city_references' do |t|
      t.string :title
      t.timestamps
      t.index :title
    end
    create_table 'position_references' do |t|
      t.string :title
      t.timestamps
      t.index :title
    end
    create_table 'specialization_references' do |t|
      t.string :title
      t.timestamps
      t.index :title
    end
  end
end
