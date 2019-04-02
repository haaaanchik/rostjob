class AddContactPersonToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :contact_person, :json
  end
end
