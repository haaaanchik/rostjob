class EmployeeCv < ApplicationRecord
  belongs_to :response

  has_attached_file :file, path: ":rails_root/storage/:class/:attachment/:id_partition/:style/:filename"

  validates_attachment_content_type :file, content_type: [%r{\Aapplication/pdf\z}, %r{\Aimage/.*}]
end
