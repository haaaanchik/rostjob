class Order < ApplicationRecord
  include AASM

  belongs_to :profile
  has_many :invites

  validates :title, presence: true
  validates :specialization, presence: true
  validates :sity, presence: true
  validates :salary_from, presence: true
  validates :salary_to, presence: true
  validates :description, presence: true
  validates :commission, presence: true
  validates :payment_type, presence: true
  validates :warranty_period, presence: true
  validates :number_of_recruiters, presence: true
  validates :accepted, presence: true

  aasm column: :state, skip_validation_on_save: true, no_direct_assignment: true do
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
