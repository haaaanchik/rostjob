class EmployeeCv < ApplicationRecord
  belongs_to :proposal

  validates :name, presence: true
  validates :gender, presence: true
  validates :birthdate, presence: true
  validates :file, presence: true

  has_attached_file :file

  validates_attachment_content_type :file, content_type: [%r{\Aapplication/pdf\z}, %r{\Aimage/.*}, %r{text/.*}]
end
