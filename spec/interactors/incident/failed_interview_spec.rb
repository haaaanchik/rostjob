require 'rails_helper'

RSpec.feature 'Incident::FailerInterview', type: :interactor do
  describe 'candidate to revoke with fail_interview' do
    let!(:incident) { create(:incident, :other) }
    let(:result) do
      Cmd::Ticket::Incident::FailedInterview.call(ticket: incident,
                                                  incident: incident,
                                                  message_params: { text: 'text' },
                                                  user: incident.proposal_employee.order.user)
    end


    it { expect(result.success?).to be(true) }
    it { expect(result.incident.closed?).to be(false) }
    it { expect(result.incident.proposal_employee.revoked?).to be(false) }
    it { expect(result.incident.proposal_employee.employee_cv.ready?).to be(false) }
    it { expect { result }.to change { ActionMailer::Base.deliveries.size }.by(1) }
    it 'create text with special prefix' do
      new_text = 'Кандидату отказано в трудоустройстве или договор разорван на основании(ях): text'

      expect(result.incident.messages.last.text).to eq(new_text)
    end
  end
end
