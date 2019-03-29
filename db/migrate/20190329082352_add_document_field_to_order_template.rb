class AddDocumentFieldToOrderTemplate < ActiveRecord::Migration[5.2]
  def up
    add_attachment :order_templates, :document
  end

  def down
    remove_attachment :order_templates, :document
  end
end
