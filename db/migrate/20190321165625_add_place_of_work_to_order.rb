class AddPlaceOfWorkToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :place_of_work, :text
  end
end
