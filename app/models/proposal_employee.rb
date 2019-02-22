class ProposalEmployee < ApplicationRecord
  include AASM

  belongs_to :proposal
  belongs_to :order
  belongs_to :profile
  belongs_to :employee_cv

  scope :available, ->(profile_id) { where(state: %w[applyed], profile_id: profile_id) }
  scope :available_free, ->(profile_id, proposal_id) { available(profile_id).where(proposal_id: proposal_id) }

  aasm column: :state do
    state :inbox, initial: true
    state :hired
    state :disputed
    state :deleted
    state :viewed
    state :revoked
    state :rejected
    state :paid

    event :to_rejected do
      transitions from: :nbox, to: :rejected
    end

    event :to_paid do
      transitions from: :hired, to: :paid
    end

    event :to_revoked do
      transitions to: :revoked
    end

    event :to_viewed do
      transitions from: :inbox, to: :viewed
    end

    event :to_disputed do
      transitions from: %i[inbox hired deleted], to: :disputed
    end

    event :to_deleted do
      transitions from: :inbox, to: :deleted
    end

    event :hire do
      transitions from: %i[inbox viewed deleted], to: :hired
    end

  end

  def mark_as_read
    update_attribute :marks, viewed_by_customer: true
  end

  def self.possible_states
    {
      inspected: 'На рассмотрении',
      applyed: 'Предложен',
      hired: 'Нанят',
      denied: 'Отказ'
    }
  end

end
