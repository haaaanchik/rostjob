class RemoveWelcomeFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :welcome, :boolean
  end
end
