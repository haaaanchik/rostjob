require 'rails_helper'

RSpec.feature 'ProposalEmployee::Hire', type: :interactor do
  describe 'hire candidate in opened orders' do
    let!(:candidate) { create(:proposal_employee, :interview) }
    let(:result) do
      Cmd::ProposalEmployee::Hire.call(order: candidate.order,
                                       candidate: candidate,
                                       hiring_date: '1.01.2020')
    end

    it { expect(result).to be_a_success }
    it { expect(result.candidate.hired?).to be(true) }
    it { expect(result.candidate.hiring_date).to eq(Date.parse('1.01.2020')) }
    it { expect(result.candidate.warranty_date).not_to be_nil }
    it { expect { result }.to change { ActionMailer::Base.deliveries.size }.by(1) }
  end

  describe 'lock hire when hiring_date is nil or empty' do
    let!(:candidate) { create(:proposal_employee, :interview) }
    let(:result) do
      Cmd::ProposalEmployee::Hire.call(order: candidate.order,
                                       candidate: candidate,
                                       hiring_date: '')
    end

    it { expect(result.be_success).to be_falsey }
  end

  describe 'lock if number_free_places == 0' do
    let!(:candidate) { create(:proposal_employee, :hired) }
    let(:result) do
      Cmd::ProposalEmployee::Hire.call(order: candidate.order,
                                       candidate: candidate,
                                       hiring_date: '1.01.2020')
    end

    before { candidate.order.update(number_of_employees: 1) }

    it { expect(result.be_success).to be_falsey }
  end
end
