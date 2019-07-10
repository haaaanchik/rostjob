class Ticket < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  accepts_nested_attributes_for :messages

  include AASM

  validates :title, presence: true

  include TicketRepository

  aasm column: :state, skip_validation_on_save: true, no_direct_assignment: false do
    state :opened, initial: true
    state :closed

    event :to_closed do
      transitions from: :opened, to: :closed
    end
  end

  def initialize(attrs = nil)
    defaults = {
    }

    attrs_with_defaults = attrs ? defaults.merge(attrs) : defaults
    super(attrs_with_defaults)
  end

  ransack_alias :all_fields, :id_or_title

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
