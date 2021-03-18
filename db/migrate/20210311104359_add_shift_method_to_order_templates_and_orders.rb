class AddShiftMethodToOrderTemplatesAndOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :order_templates, :shift_method, :boolean, null: false, default: false
    add_column :orders, :shift_method, :boolean, null: false, default: false
  end
end
