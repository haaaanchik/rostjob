require 'rails_helper'

RSpec.feature 'ProposalEmployee::Revoke', type: :interactor do
  describe "revoke candidate" do
    let!(:candidate) { create(:proposal_employee, :interview) }
    let(:result) { Cmd::ProposalEmployee::Revoke.call(proposal_employee: candidate, user: candidate.user) }

    it { expect(result).to be_a_success }
    it { expect(result.candidate.revoked?).to be(true) }
    it { expect(result.candidate.employee_cv.ready?).to be(true) }
    it { expect { result }.to change { ActionMailer::Base.deliveries.size }.by(1) }
  end
end
