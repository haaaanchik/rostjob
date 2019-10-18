class Ticket < ApplicationRecord
  include AASM
  include TicketRepository

  belongs_to :user
  belongs_to :proposal_employee, required: false
  has_many :messages, dependent: :destroy
  accepts_nested_attributes_for :messages

  validates :title, presence: true

  aasm :state, column: :state, skip_validation_on_save: true, no_direct_assignment: false do
    state :opened, initial: true
    state :closed

    event :to_closed do
      transitions from: :opened, to: :closed
    end
  end

  aasm :waiting, column: :waiting, skip_validation_on_save: true, no_direct_assignment: false do
    state :customer, initial: true
    state :contractor

    event :to_contractor do
      transitions from: :customer, to: :contractor
    end
  end

  def initialize(attrs = nil)
    defaults = {
    }

    attrs_with_defaults = attrs ? defaults.merge(attrs) : defaults
    super(attrs_with_defaults)
  end

  ransack_alias :all_fields, :id_or_title
  ransack_alias :state_waiting_fields, :state_or_waiting

  ransacker :id do
    Arel.sql("CONVERT(#{table_name}.id, CHAR(8))")
  end

  def appeal?
    is_a? Appeal
  end

  def incident?
    is_a? Incident
  end
end
