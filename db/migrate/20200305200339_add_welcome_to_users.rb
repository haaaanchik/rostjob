class AddWelcomeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :welcome, :boolean, default: false

    User.all.each do |user|
      user.welcome = true
      user.skip_reconfirmation!
      user.save(validate: false)
    end
  end
end
