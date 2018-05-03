class AddFieldsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :full_name, :string
    add_column :users, :provider, :string
    add_column :users, :url, :string
    add_column :users, :uid, :string
  end
end
