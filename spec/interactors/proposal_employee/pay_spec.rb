require 'rails_helper'

RSpec.feature 'ProposalEmployee::Pay', type: :interactor do
  describe "pay for a candidate" do
    let!(:candidate) { create(:proposal_employee, :approved) }
    let(:result) { Cmd::ProposalEmployee::Pay.call(candidate: candidate) }

    it { expect(result).to be_a_success }
    it { expect(result.candidate.paid?).to be(true) }
    it { expect(result.candidate.payment_date.to_date).to eq(Date.today) }
    it { expect { result }.to change { ActionMailer::Base.deliveries.size }.by(1) }
  end
end
