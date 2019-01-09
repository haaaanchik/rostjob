class AddConfirmableToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    User.where('sign_in_count > 0').map {|d| d.touch(:confirmed_at)}
  end
end
