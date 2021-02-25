class AddAttachmentImageToSpecializations < ActiveRecord::Migration[5.2]
  def self.up
    change_table :specializations do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :specializations, :image
  end
end
