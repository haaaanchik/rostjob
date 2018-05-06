class Proposal < ApplicationRecord
  include AASM

  belongs_to :order
  belongs_to :profile
  has_many :messages
  has_many :employee_cvs

  aasm column: :state, skip_validation_on_save: true, no_direct_assignment: true do
    state :active, initial: true
    state :completed

    event :complete do
      transitions from: :active, to: :completed
    end
  end
end
