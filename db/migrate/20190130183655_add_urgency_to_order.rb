class AddUrgencyToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :urgency, :string
  end
end
