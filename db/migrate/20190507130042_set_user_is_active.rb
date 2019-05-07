class SetUserIsActive < ActiveRecord::Migration[5.2]
  def up
    User.find_each do |user|
      user.update_attribute(:is_active, true) if user.is_active.nil?
    end
  end

  def down; end
end
