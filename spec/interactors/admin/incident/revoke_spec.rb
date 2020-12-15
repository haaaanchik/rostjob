require 'rails_helper'

RSpec.feature 'Admin::Incident::Revoke', type: :interactor do
  describe 'revoke candidate' do
    let(:incident) { create(:incident, :other) }
    let(:admin) { create(:staffer, :admin) }

    let(:result) do
      Cmd::Ticket::Incident::Revoke.call(ticket: incident,
                                         incident: incident,
                                         user: admin.decorate,
                                         proposal_employee: incident.proposal_employee,
                                         message_params: { text: 'Анкеты была отозвона, администрацией.' }
                                        )
    end

    it { expect(result.proposal_employee.revoked?).to be(true) }
  end
end
