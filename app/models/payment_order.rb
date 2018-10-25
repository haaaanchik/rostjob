class PaymentOrder < ApplicationRecord
  include AASM

  belongs_to :company

  aasm column: :state, skip_validation_on_save: true, no_direct_assignment: true do
    state :created, initial: true
    state :completed

    event :complete do
      transitions from: :created, to: :completed
    end
  end
end
