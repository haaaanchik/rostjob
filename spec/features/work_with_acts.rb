require 'rails_helper'

RSpec.feature 'Work with acts', type: :feature do
  context 'aprove act to paid' do
    let!(:candidate) { create(:proposal_employee, :approved) }
    let!(:cv_2) {create(:employee_cv, profile: candidate.profile, phone_number: '+7(955)-555-55-65') }
    let!(:candidate_2) do
      ProposalEmployee.create(profile: candidate.profile, order: candidate.order,
                              employee_cv: cv_2, state: :approved)
    end

    before(:each) { sign_in(candidate.order.profile.user) }

    scenario 'to paid one act', js: true do
      click_on('Акты', match: :first)

      expect(page).to have_content(candidate.employee_cv.name)
      click_link('Подписать акт', match: :first)
      sleep(1)

      expect(ProposalEmployee.paid.count).to eq(1)
      expect(page).not_to have_content(ProposalEmployee.paid.last.employee_cv.name)
    end

    scenario 'to paid list acts', js: true do
      click_on('Акты', match: :first)
      click_link('Подписать все')
      sleep(1)

      expect(ProposalEmployee.paid.count).to eq(2)
      expect(ProposalEmployee.last.state).to eq('paid')
    end
  end
end