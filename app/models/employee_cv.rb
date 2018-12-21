class EmployeeCv < ApplicationRecord
  include AASM

  belongs_to :proposal, optional: true
  belongs_to :order, optional: true
  belongs_to :profile, optional: true

  validates :name, presence: true
  validates :gender, presence: true
  validates :birthdate, presence: true

  has_attached_file :file

  unless Gem.win_platform?
    validates :file, presence: true
    validates_attachment_content_type :file, content_type: [%r{\Aapplication/pdf\z}, %r{\Aimage/.*}, %r{text/.*}]
  end

  aasm column: :state, skip_validation_on_save: true, no_direct_assignment: false do
    state :draft
    state :applyed, initial: true
    state :hired
    state :fired
    state :charged

    event :apply do
      transitions from: :draft, to: :applyed
    end

    event :hire do
      transitions from: :applyed, to: :hired
    end

    event :fire do
      transitions from: :hired, to: :fired
    end

    event :charge do
      transitions from: :hired, to: :charged
    end
  end

  def self.ext_data_fields
    %i[pser pnum pdate pcode address phone phone_alt education experiense remark]
  end
end
