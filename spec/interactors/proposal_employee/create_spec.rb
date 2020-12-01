require 'rails_helper'

RSpec.feature 'ProposalEmployee::Create', type: :interactor do
  describe "create candidate" do
    let(:order) { create(:order) }
    let(:contractor) { create(:contractor) }
    let(:employee_cv) { create(:employee_cv, :ready, profile: contractor.profile) }
    let(:result) do
      Cmd::ProposalEmployee::Create.call(order: order,
                                         employee_cv: employee_cv,
                                         profile: contractor.profile,
                                         interview_date: '1.01.2020'
                                        )
    end

    it { expect(result).to be_a_success }
    it { expect(result.proposal_employee.interview?).to be(true) }
    it { expect(result.employee_cv.sent?).to be(true) }
    it { expect(result.proposal_employee.interview_date.to_date).to eq(Date.parse('1.01.2020')) }
  end
end
