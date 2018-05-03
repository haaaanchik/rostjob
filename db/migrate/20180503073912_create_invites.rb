class CreateInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :invites do |t|
      t.string :title
      t.text :description
      t.string :state
      t.references :order, foreign_key: true
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
