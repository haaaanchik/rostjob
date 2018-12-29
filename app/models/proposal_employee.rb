class ProposalEmployee < ApplicationRecord
  include AASM

  belongs_to :proposal
  belongs_to :order
  belongs_to :profile
  belongs_to :employee_cv

  scope :available, ->(profile_id) {where(state: %w[applyed], profile_id: profile_id)}
  scope :available_free, ->(profile_id, proposal_id) {available(profile_id).where(proposal_id: proposal_id)}

  aasm column: :state do
    state :applyed, initial: true
    state :inspected
    state :hired
    state :denied

    event :make_inspected do
      transitions from: :applyed, to: :inspected
    end

    event :hire do
      transitions from: %i[applyed inspected], to: :hired
      after do
        self.update_attributes date_hired: Date.current
      end
    end

    event :deny do
      transitions from: %i[applyed inspected], to: :denied
      after do
        self.update_attributes date_hired: Date.current
      end
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
