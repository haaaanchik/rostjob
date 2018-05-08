class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :phone
      t.string :email
      t.string :contact_person
      t.string :company_name
      t.string :profile_type
      t.text :description
      t.string :city
      t.string :rating
      t.timestamp :last_seen
      t.string :state
      t.attachment :photo

      t.timestamps
    end
  end
end
