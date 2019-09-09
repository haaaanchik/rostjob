class AddManagerFlagToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :manager, :boolean
  end
end
