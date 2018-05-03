class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :text
      t.boolean :income
      t.references :proposal, foreign_key: true

      t.timestamps
    end
  end
end
