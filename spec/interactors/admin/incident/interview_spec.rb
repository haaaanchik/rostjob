require 'rails_helper'

RSpec.feature 'Admin::Incident::Interview', type: :interactor do
  describe "create incident" do
    let(:incident) { create(:incident, :other) }
    let(:admin) { create(:staffer, :admin) }
    let(:result) do
      Cmd::Admin::Ticket::Incident::Interview.call(proposal_employee: incident.proposal_employee,
                                                    message_params: { text: 'Для анкеты назначена дата приезда, администратором.' },
                                                    interview_date: '1.01.2020',
                                                    incident: incident,
                                                    ticket: incident,
                                                    user: admin.decorate
                                                  )
    end

    it { expect(result.proposal_employee.interview?).to be(true) }
    it { expect(result.incident.closed?).to be(true) }
    it { expect(result.proposal_employee.interview_date.to_date).to eq(Date.parse('1.01.2020')) }
    it { expect(result.message.text).to eq('Для анкеты назначена дата приезда, администратором.') }
  end
end
