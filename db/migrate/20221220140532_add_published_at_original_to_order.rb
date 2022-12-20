class AddPublishedAtOriginalToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :published_at_original, :date
  end
end
