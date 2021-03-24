class SetSlugForUsers < ActiveRecord::Migration[5.2]
  def up
    User.joins(:profile).where('profiles.profile_type': 'contractor', slug: nil).each do |user|
      user.set_user_slug
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
