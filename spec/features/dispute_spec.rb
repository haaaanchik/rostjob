require 'rails_helper'

RSpec.feature 'Disputed', type: :feature do
  context 'customer start dispute' do
    let!(:candidate) { create(:proposal_employee, :interview) }

    before(:each) do
      sign_in(candidate.order.profile.user)
      find('#production-site-list').click
      find('#first_pr_site').click
      click_link(candidate.order.title)
      click_link(candidate.employee_cv.name)

      find('a', text: 'Спор').click
      sleep(1)
    end

    scenario 'customer create dispute', js: true do
      page.execute_script("$('#incident_title_not_come').prop('checked', true)")
      fill_in 'Текст спора',	with: 'My text dispute'

      click_on 'Отправить'
      sleep(1)
      expect(ProposalEmployee.last.state).to eq('disputed')

      expect(ProposalEmployee.last.incidents.last.title).to eq('not_come')
      expect(ProposalEmployee.last.incidents.last.state).to eq('opened')
    end

    scenario 'cant create without reason', js: true do
      fill_in 'Текст спора',	with: 'My text dispute'

      click_on 'Отправить'
      sleep(1)

      expect(ProposalEmployee.disputed.count).to eq(0)
    end

    scenario 'cant create without message', js: true do
      page.execute_script("$('#incident_title_not_come').prop('checked', true)")

      click_on 'Отправить'
      sleep(1)

      expect(ProposalEmployee.disputed.count).to eq(0)
    end
  end
end