class Incident < Ticket
  extend Enumerize

  validates :proposal_employee_id, presence: true
  validates :reason, presence: true

  enumerize :reason, in: { other: 0, not_come: 1 }, default: :other

  after_create :mail_for_contractor_has_incident, if: -> { opened? }

  private

  def mail_for_contractor_has_incident
    SendNotifyMailJob.perform_now(objects: [self], method: 'informated_contractor_has_disputed')
  end
end
