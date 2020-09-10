require 'rails_helper'

RSpec.feature 'Admin::Incident::Hire', type: :interactor do
  describe 'hired candidate' do
    let(:incident) { create(:incident, :other) }
    let(:admin) { create(:staffer, :admin) }
    let(:result) do
      Cmd::Ticket::Incident::Hire.call(candidate: incident.proposal_employee,
                                       message_params: { text: 'Для анкеты назначена дата найма, администратором.' },
                                       hiring_date: '1.01.2020',
                                       incident: incident,
                                       ticket: incident,
                                       user: admin.decorate,
                                       order: incident.proposal_employee.order
                                      )
    end


    it { expect(result.success?).to be(true) }
    it { expect(result.message.text).to eq('Для анкеты назначена дата найма, администратором.') }
    it { expect { result }.to change { ActionMailer::Base.deliveries.size }.by(1) }
  end
end
