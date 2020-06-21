require 'rails_helper'

RSpec.feature 'ProposalEmployee', type: :feature do
  context 'contractor actions' do
    context 'work with orders' do
      let!(:order) { create(:created_order) }
      let(:contractor) { create(:contractor) }
      let(:employee_cv) { attributes_for(:employee_cv) }
      let(:customer) { order.profile.user }

      before(:each) do
        sign_in(contractor)
        click_link('Каталог заявок')

        have_link("Перейти к заявкам", href: orders_by_customer_path(customer))
        visit orders_by_customer_path(customer)
        page.execute_script("$('.js-vacancy')[0].click()")
      end

      scenario 'send news candidate to order', js: true do
        expect(Order.last.proposal_employees.count).to eq(0)

        click_link('Отправить анкету')
        sleep(1)

        within('.new-employee_cv-form') do
          fill_in 'employee_cv_name',         with: employee_cv[:name]
          fill_in 'employee_cv_phone_number', with: '9888888888'
          fill_in 'employee_cv_experience',   with: employee_cv[:experience]
          fill_in 'employee_cv_education',    with: employee_cv[:education]
          fill_in 'employee_cv_remark',       with: employee_cv[:remark]

          click_button('Отправить')
        end

        sleep(1)

        expect(Order.last.proposal_employees.count).to eq(1)
      end

      scenario 'add order to favorite', js: true do
        click_link('Добавить в избранные')
        sleep(1)

        expect(Profile.contractors.last.favorites.count).to eq(1)
      end
    end

    context 'working in CRM' do
      let(:contractor) { create(:contractor) }
      let(:employee_cv) { attributes_for(:employee_cv) }

      before(:each) do
        sign_in(contractor)
        click_link('Список Анкет', match: :first)
        click_link('Добавить анкету', match: :first)
        sleep(1)
      end

      scenario 'add candidate without reminder', js: true do
        within('.new-employee_cv-form') do
          fill_in 'employee_cv_name',         with: employee_cv[:name]
          fill_in 'employee_cv_phone_number', with: '9888888888'
          fill_in 'employee_cv_experience',   with: employee_cv[:experience]
          fill_in 'employee_cv_education',    with: employee_cv[:education]
          fill_in 'employee_cv_remark',       with: employee_cv[:remark]

          click_button('Сохранить')
        end

        expect(page).to have_content(employee_cv[:name])
      end

      scenario 'add candidate with reminder', js: true do
        within('.new-employee_cv-form') do
          fill_in 'employee_cv_name',         with: employee_cv[:name]
          fill_in 'employee_cv_phone_number', with: '9888888888'
          fill_in 'employee_cv_experience',   with: employee_cv[:experience]
          fill_in 'employee_cv_education',    with: employee_cv[:education]
          fill_in 'employee_cv_remark',       with: employee_cv[:remark]
          page.execute_script("$('#reminder_disable_checkbox').click()")

          click_button('Сохранить')
        end

        sleep(1)

        expect(EmployeeCv.where(profile_id: contractor.id).where.not(comment: nil).count).to eq(1)
      end
    end
  end

  context 'customer actions' do
    context 'candidates indox -> interview' do
      let!(:order_with_candidate) { create(:proposal_employee)}

      before(:each) do
        sign_in(order_with_candidate.order.profile.user)
        find('#production-site-list').click
        find('#first_pr_site').click
        click_link(order_with_candidate.order.title)
      end

      scenario 'show new candidate' do
        expect(page).to have_content(order_with_candidate.employee_cv.name)
      end


      ## CAN"T FIND BUTTON
      # scenario 'revoke candidate', js: true do
      #   click_link(order_with_candidate.employee_cv.name)
      #   sleep(1)

      #   find("a", text: 'Отозвать').click
      #   sleep(1)
      #   # find('.enjoyhint_close_btn').click
      #   save_and_open_page
      #   click_button('Да')
      #   save_and_open_page
      #   expect(page).not_to have_content(order_with_candidate.employee_cv.name)
      #   save_and_open_page
      # end

      scenario 'set date_interview to candidate', js: true do
        click_link(order_with_candidate.employee_cv.name)
        sleep(1)

        click_on('Назначить')
        sleep(1)
        expect(ProposalEmployee.last.state).to eq('interview')
      end
    end

    context 'candidates interview -> hire' do
      let!(:order_with_candidate) { create(:proposal_employee, :interview) }

      scenario 'hire cadidate', js: true do
        sign_in(order_with_candidate.order.profile.user)
        find('#production-site-list').click
        find('#first_pr_site').click
        click_link(order_with_candidate.order.title)

        click_link(order_with_candidate.employee_cv.name)
        sleep(1)

        click_on('Нанять')
        sleep(1)

        expect(ProposalEmployee.last.state).to eq('hired')
      end
    end

    context 'candidate hire -> aprove' do
      let!(:order_with_candidate) { create(:proposal_employee, :hired) }

      scenario 'approve cadidate', js: true do
        sign_in(order_with_candidate.order.profile.user)
        find('#production-site-list').click
        find('#first_pr_site').click
        click_link(order_with_candidate.order.title)

        click_link(order_with_candidate.employee_cv.name)
        sleep(1)

        click_on('Подтвердить гарантию')
        sleep(1)
        expect(ProposalEmployee.last.state).to eq('approved')
      end
    end
  end
end