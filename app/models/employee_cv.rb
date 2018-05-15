class EmployeeCv < ApplicationRecord
  belongs_to :proposal

  validates :name, presence: true
  validates :gender, presence: true
  validates :birthdate, presence: true
  validates :file, presence: true

  has_attached_file :file, path: ":rails_root/storage/:class/:attachment/:id_partition/:style/:filename"

  validates_attachment_content_type :file, content_type: [%r{\Aapplication/pdf\z}, %r{\Aimage/.*}, %r{text/.*}]
end
