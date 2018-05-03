class Order < ApplicationRecord
  include AASM

  belongs_to :profile
  has_many :invites

  aasm column: :state do
    state :draft, initial: true
    state :active
    state :completed

    event :activate do
      transitions from: :draft, to: :active
    end

    event :complete do
      transitions from: :active, to: :completed
    end
  end
end
