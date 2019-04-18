class AddUrgencyLevelToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :urgency_level, :string
  end
end
