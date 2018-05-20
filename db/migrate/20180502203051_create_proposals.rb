class CreateProposals < ActiveRecord::Migration[5.2]
  def change
    create_table :proposals do |t|
      t.text :description
      t.string :state
      t.boolean :accepted
      t.references :order, foreign_key: true
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
