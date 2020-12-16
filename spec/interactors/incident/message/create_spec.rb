require 'rails_helper'

RSpec.feature 'Incident::Message::Create', type: :interactor do
  describe "test send notify mail" do
    let(:incident) { create(:incident, :other) }
    let(:customer) { incident.user }
    let(:result) do
      Cmd::Ticket::Message::Create.call(user: customer,
                                        ticket: incident,
                                        message_params: { text: 'test'}
                                      )
    end

    it { expect(result).to be_a_success }
    it { expect(result.ticket.waiting).to eq('customer') }
    it { expect { result }.to change { ActionMailer::Base.deliveries.size }.by(2) }
  end

  describe "test change for wait" do
    let(:incident) { create(:incident, :other) }
    let(:recruter) { incident.proposal_employee.user }
    let(:result) do
      Cmd::Ticket::Message::Create.call(user: recruter,
                                        ticket: incident,
                                        message_params: { text: 'test'}
                                      )
    end

    it { expect(result.ticket.waiting).to eq('contractor') }
    #1 mail with history admin second to reponts user
    it { expect { result }.to change { ActionMailer::Base.deliveries.size }.by(2) }
  end

  describe 'dont must change waiting if message sended by staffer' do
    let(:incident) { create(:incident, :other) }
    let(:admin)    { create(:staffer, :admin) }
    let(:result) do
      Cmd::Ticket::Message::Create.call(ticket: incident,
                                        user: admin.decorate,
                                        message_params: { text: 'test'}
                                       )
    end

    it { expect(result.ticket.waiting).to eq('customer') }
  end
end
