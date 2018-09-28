class AddPositionIdToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :position_id, :integer
  end
end
