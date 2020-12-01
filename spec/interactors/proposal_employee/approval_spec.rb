require 'rails_helper'

RSpec.feature 'ProposalEmployee::Approval', type: :interactor do
  describe "approvaled candidate" do
    let(:candidate) { create(:proposal_employee, :hired) }
    let(:result) { Cmd::ProposalEmployee::Approval.call(candidate: candidate) }

    it { expect(result).to be_a_success }
    it { expect(result.candidate.approved?).to be(true) }
    it { expect(result.candidate.approved_by_admin).to be(false) }
  end
end
