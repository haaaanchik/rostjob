class Incident < Ticket
  extend Enumerize

  belongs_to :proposal_employee
  validates :proposal_employee_id, presence: true
  validates :reason, presence: true

  enumerize :reason, in: { other: 0, not_come: 1 }, default: :other
end
