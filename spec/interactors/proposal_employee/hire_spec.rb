require 'rails_helper'

RSpec.feature 'ProposalEmployee::Hire', type: :interactor do
  describe "hire candidate" do
    let!(:candidate) { create(:proposal_employee, :interview) }
    let(:result) do
      Cmd::ProposalEmployee::Hire.call(candidate: candidate,
                                       hiring_date: '1.01.2020'
                                      )
    end

    it { expect(result).to be_a_success }
    it { expect(result.candidate.hired?).to be(true) }
    it { expect(result.candidate.hiring_date).to eq(Date.parse('1.01.2020')) }
    it { expect(result.candidate.warranty_date).not_to be_nil }
    it { expect { result }.to change { ActionMailer::Base.deliveries.size }.by(1) }
  end
end
