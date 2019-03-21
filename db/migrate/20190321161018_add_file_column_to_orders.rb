class AddFileColumnToOrders < ActiveRecord::Migration[5.2]
  def up
    add_attachment :orders, :document
  end

  def down
    remove_attachment :orders, :document
  end
end
