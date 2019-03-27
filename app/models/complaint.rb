class Complaint < ApplicationRecord
  include AASM

  belongs_to :proposal_employee
  belongs_to :profile

  aasm column: :state, skip_validation_on_save: true, no_direct_assignment: false, whiny_transitions: false do
    state :opened, initial: true
    state :closed

    event :to_closed do
      transitions from: :opened, to: :closed
    end
  end
end
