require 'rails_helper'

RSpec.feature 'Incident::FailerInterview', type: :interactor do
  describe 'revoke candidate aftr fail_interview' do
    let!(:incident) { create(:incident, :other) }
    let(:result) do
      Cmd::Ticket::Incident::FailedInterview.call(ticket: incident,
                                                  incident: incident,
                                                  message_params: { text: 'some text' },
                                                  user: incident.proposal_employee.order.user,
                                                  proposal_employee: incident.proposal_employee
                                                )
    end


    it { expect(result.success?).to be(true) }
    it { expect(result.incident.closed?).to be(true) }
    it { expect(result.candidate.revoked?).to be(true) }
    it { expect(result.candidate.employee_cv.ready?).to be(true) }
    it { expect(result.incident.messages.last.text).to eq('some text') }
    it { expect { result }.to change { ActionMailer::Base.deliveries.size }.by(1) }
  end
end
