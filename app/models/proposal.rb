class Proposal < ApplicationRecord
  include AASM

  belongs_to :order
  belongs_to :profile
  has_many :messages
  has_many :employee_cvs

  validates :description, presence: true
  validates :profile_id, uniqueness: { scope: :order_id, message: 'Proposal already exists' }

  aasm column: :state, skip_validation_on_save: true, no_direct_assignment: true do
    state :sent, initial: true
    state :accepted
    state :rejected
    state :completed

    event :accept do
      transitions from: :sent, to: :accepted
    end

    event :reject do
      transitions from: :sent, to: :rejected
    end

    event :complete do
      transitions from: :accepted, to: :completed
    end
  end
end
