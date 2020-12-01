require 'rails_helper'

RSpec.feature 'Incident::Interview', type: :interactor do
  describe "create incident" do
    let(:incident) { create(:incident, :other) }
    let(:result) do
      Cmd::Ticket::Incident::Interview.call(candidate: incident.proposal_employee,
                                            message_params: { text: 'Для анкеты назначена дата найма.' },
                                            interview_date: '1.01.2020',
                                            incident: incident,
                                            ticket: incident,
                                            user: incident.proposal_employee.order.user,
                                           )
    end


    it { expect(result.success?).to be(true) }
    it { expect(result.candidate.interview?).to be(true) }
    it { expect(result.incident.closed?).to be(true) }
    it { expect(result.candidate.interview_date.to_date).to eq(Date.parse('1.01.2020')) }
    it { expect(result.incident.messages.last.text).to eq('Для анкеты назначена дата найма.') }
    it { expect { result }.to change { ActionMailer::Base.deliveries.size }.by(1) }
  end
end
