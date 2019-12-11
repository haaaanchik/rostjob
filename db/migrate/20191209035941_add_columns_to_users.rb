class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :password_changed_at, :datetime
    add_column :users, :terms_of_service, :boolean, default: false
    add_column :users, :first_order_template_created, :boolean, default: false
    add_column :profiles, :updated_by_self_at, :datetime
  end
end
