class AddIndexToPublishedAtOriginal < ActiveRecord::Migration[5.2]
  def change
    add_index:orders, :published_at_original, unique: false
  end
end
