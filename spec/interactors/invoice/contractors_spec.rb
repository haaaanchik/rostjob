require 'rails_helper'

RSpec.feature 'Invoice::Contractors', type: :interactor do
  describe 'create incident' do
    let!(:candidate) { create(:proposal_employee, :paid, approved_by_admin: true) }
    let(:profile) { candidate.profile }
    let!(:update_balance) { profile.balance.deposit(1111, 'sss')}
    it { expect(candidate.invoice).to be(nil) }

    let(:result) do
      Cmd::Profile::Balance::Withdrawal.call(profile: profile,
                                             invoice: profile.invoices.new,
                                             company: profile.withdrawal_methods.last.company,
                                             reason_text: 'Перевод вознаграждения исполнителю')
    end
  end
end
