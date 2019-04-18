class AddUrgencyLevelToOrderTemplate < ActiveRecord::Migration[5.2]
  def change
    add_column :order_templates, :urgency_level, :string
  end
end
