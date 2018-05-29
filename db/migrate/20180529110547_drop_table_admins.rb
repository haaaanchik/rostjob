require_relative '20180514074133_devise_create_admins'

class DropTableAdmins < ActiveRecord::Migration[5.2]
  def change
    revert DeviseCreateAdmins
  end
end
