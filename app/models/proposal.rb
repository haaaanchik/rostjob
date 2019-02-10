class Proposal < ApplicationRecord
  include AASM

  belongs_to :order
  belongs_to :profile
  has_many :messages, dependent: :destroy
  has_many :employee_cvs, dependent: :nullify

  has_many :proposal_employees
  has_many :orders, through: :proposal_employees

  accepts_nested_attributes_for :messages
  accepts_nested_attributes_for :employee_cvs

  validates :profile_id, uniqueness: { scope: :order_id, message: 'Proposal already exists' }

  aasm column: :state, skip_validation_on_save: true, no_direct_assignment: true do
    state :sent, initial: true
    state :cancelled

    event :cancel do
      transitions from: :sent, to: :cancelled
    end

    event :resend do
      transitions from: :cancelled, to: :sent
    end
  end
end
