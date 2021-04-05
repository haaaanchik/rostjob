require 'rails_helper'

RSpec.feature 'Cmd::Admin::Ticket::Incident::Hire', type: :interactor do
  describe 'hire to closed order' do
    let(:incident) { create(:incident, :other) }
    let(:admin) { create(:staffer, :admin) }
    let(:result) do
      Cmd::Admin::Ticket::Incident::Hire.call(candidate: incident.proposal_employee,
                                              message_params: { text: 'Для анкеты назначена дата найма, администратором.' },
                                              hiring_date: '1.01.2020',
                                              incident: incident,
                                              ticket: incident,
                                              user: admin.decorate,
                                              order: incident.proposal_employee.order)

    end
    let!(:set_number_of_employees) { incident.proposal_employee.order.update(number_of_employees: 0) }

    it { expect(result.success?).to be(true) }
    it { expect(result.incident.proposal_employee.hired?).to be(true) }
    it { expect(result.message.text).to eq('Для анкеты назначена дата найма, администратором.') }
    it { expect { result }.to change { ActionMailer::Base.deliveries.size }.by(1) }
    it { expect(result.incident.closed?).to be(true) }
  end
end
