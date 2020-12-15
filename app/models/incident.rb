class Incident < Ticket
  extend Enumerize

  validates :proposal_employee_id, presence: true
  validates :reason, presence: true

  enumerize :title, in: %i[not_come denied fail_interview didnt_work other]
  enumerize :reason, in: { other: 0, not_come: 1, fail_interview: 2 }, default: :other
end
