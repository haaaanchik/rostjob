class AddContactPersonToOrderTemplate < ActiveRecord::Migration[5.2]
  def change
    add_column :order_templates, :contact_person, :json
  end
end
