class CreateSpecializations < ActiveRecord::Migration[5.2]
  def change
    create_table :specializations do |t|
      t.string :title

      t.timestamps
    end
    add_index :specializations, :title
  end
end
