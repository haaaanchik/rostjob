require 'rails_helper'

RSpec.feature 'Disputed', type: :feature do
  context 'customer start dispute' do
    let!(:candidate) { create(:proposal_employee, :interview) }

    before(:each) do
      sign_in(candidate.order.profile.user)
      visit profile_production_site_order_path(candidate.order.production_site, candidate.order)

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
  context 'customer close dispute' do
    context 'reason - not_come candidate' do
      let(:incident) { create(:incident, :not_come) }

      before(:each) do
        sign_in(incident.user)
        visit profile_ticket_path(incident)
      end

      scenario 'send candidate to interview again', js: true do
        expect(Incident.last.state).to eq('opened')
        expect(ProposalEmployee.last.state).to eq('disputed')

        find('span', text: 'Мы приглашаем кандидата на собеседования').click
        click_on('НАЗНАЧИТЬ')
        sleep(1)

        expect(Incident.last.state).to eq('closed')
        expect(ProposalEmployee.last.state).to eq('interview')
      end

      scenario 'hire candidate', js: true do
        find('span', text: 'Мы нанимаем кандидата').click
        click_on('НАНЯТЬ')
        sleep(1)

        expect(Incident.last.state).to eq('closed')
        expect(ProposalEmployee.last.state).to eq('hired')
      end
    end

    context 'reason - other' do
      let(:incident) { create(:incident, :other) }

      before(:each) do
        sign_in(incident.user)
        visit profile_ticket_path(incident)
      end

      scenario 'other reason - change data interview', js: true do
        find('span', text: 'Кандидат явился на собеседование, я хочу указать дату нанятия').click
        click_on('НАНЯТЬ')

        sleep(1)
        expect(Incident.last.state).to eq('closed')
        expect(ProposalEmployee.last.state).to eq('hired')
      end

      scenario 'other reason - failed interview' do
        find('span', text: 'Кандидат явился, но не прошел собеседование')
        fill_in 'incident_messages_attributes_0_text', with: 'reason to failed candidate'
        click_on('ОТПРАВИТЬ')

        sleep(1)
        expect(Incident.last.state).to eq('closed')
        expect(ProposalEmployee.last.state).to eq('rejected')
      end
    end
  end

  context 'contractor close disputed' do
    let(:incident) { create(:incident, :not_come) }

    before(:each) do
      sign_in(incident.proposal_employee.profile.user)
      visit profile_ticket_path(incident)
    end

    scenario 'revoke candidate', js: true do
      find('span', text: 'Да, кандидат не явился на собеседование, я хочу вернуть анкету').click

      sleep(1)
      expect(Incident.last.state).to eq('closed')
      expect(ProposalEmployee.last.state).to eq('revoked')
    end

    scenario 'change data inteview', js: true do
      find('span', text: 'Да, кандидат не явился на собеседование, я хочу изменить дату приезда').click
      click_on('НАЗНАЧИТЬ')

      sleep(1)
      expect(Incident.last.state).to eq('closed')
      expect(ProposalEmployee.last.state).to eq('inbox')
    end

    scenario 'incident when candidate come but customer has disput', js: true do
      find('span', text: 'Нет, кандидат был на собеседование, уточните пожалуйста').click

      sleep(1)
      expect(Incident.last.state).to eq('opened')
      expect(Incident.last.waiting).to eq('customer')
      expect(ProposalEmployee.last.state).to eq('disputed')
    end
  end
end
