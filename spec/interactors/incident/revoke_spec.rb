require 'rails_helper'

RSpec.feature 'Incident::Revoke', type: :interactor do
  describe 'revoke candidate' do
    let(:incident) { create(:incident, :other) }
    let(:result) do
      Cmd::Ticket::Incident::Revoke.call(ticket: incident,
                                         incident: incident,
                                         user: incident.proposal_employee.order.user,
                                         proposal_employee: incident.proposal_employee,
                                         message_params: { text: 'Анкеты была отозвона' }
                                        )
    end


    it { expect(result.success?).to be(true) }
    it { expect(result.candidate.revoked?).to be(true) }
    it { expect(result.incident.closed?).to be(true) }
    it { expect(result.candidate.employee_cv.ready?).to eq(true) }
    it { expect(result.incident.messages.last.text).to eq('Анкеты была отозвона') }
    it { expect { result }.to change { ActionMailer::Base.deliveries.size }.by(1) }
  end
end
