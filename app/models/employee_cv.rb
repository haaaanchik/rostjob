class EmployeeCv < ApplicationRecord
  include AASM

  belongs_to :proposal
  belongs_to :order, optional: true

  validates :name, presence: true
  validates :gender, presence: true
  validates :birthdate, presence: true
  validates :file, presence: true

  has_attached_file :file

  validates_attachment_content_type :file, content_type: [%r{\Aapplication/pdf\z}, %r{\Aimage/.*}, %r{text/.*}]

  aasm column: :state, skip_validation_on_save: true, no_direct_assignment: false do
    state :applyed, initial: true
    state :hired
    state :fired

    event :hire do
      transitions from: :applyed, to: :hired
    end

    event :fire do
      transitions from: :hired, to: :fired
    end
  end
end
