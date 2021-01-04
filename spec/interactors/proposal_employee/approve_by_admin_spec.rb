require 'rails_helper'

RSpec.feature 'ProposalEmployee::AdminApproval', type: :interactor do
  describe "approved by admin" do
    let!(:candidate) { create(:proposal_employee, :paid) }
    let(:result) { Cmd::ProposalEmployee::AdminApproval.call(candidate: candidate) }

    it { expect(result).to be_a_success }
    it { expect(result.candidate.approved_by_admin).to be(true) }
    it { expect { result }.to change { ActionMailer::Base.deliveries.size }.by(1) }
  end
end
