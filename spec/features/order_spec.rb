require 'rails_helper'

RSpec.feature 'Order', type: :feature do
  context 'create new order' do
    let!(:price_group) { create(:price_group) }
    let!(:city) { create(:city) }
    let(:position) { price_group.positions.first }
    let(:order) { attributes_for(:order) }

    scenario 'create new order', js: true do
      expect(Order.count).to eq(0)

      sign_in(:customer, :with_production_site)
      find('#production-site-list').click

      click_link('Добавить заявку')

      within('#order_template_form') do
        page.execute_script("$('#order_template_position_search').val('#{position.title}')")
        page.execute_script("$('#profession_price').val('#{price_group.customer_price}')")
        page.execute_script("$('#order_template_position_id').val('#{position.id}')")
        fill_in 'order_template_skill', with: order[:skill]
      end
      click_button('Далее')
      sleep(1)

      within('#order_template_form') do
        fill_in 'order_template_city', with: city.title
        fill_in 'order_template_salary', with: order[:salary]
      end
      click_button('Далее')
      sleep(1)

      fill_in 'contact-face', with: order[:contact_person][:name]
      fill_in 'contact-face-number', with: order[:contact_person][:phone]

      page.execute_script("tinyMCE.get('order_template_other_info_remark').setContent('TEXT')")
      find_by_id('send').click
      sleep(1)

      find_by_id('order_publish').click

      expect(Order.count).to eq(1)
    end
  end

  context 'edit order' do
    let!(:order) { create(:order) }
    let(:new_contact) { 'new contact name' }

    scenario 'edit order' do
      sign_in(order.profile.user)
      find('#production-site-list').click
      find('#first_pr_site').click
      click_link(order.title)
      click_link('Редактировать')

      click_link('Далее')

      click_button('Далее')

      fill_in 'contact-face', with: new_contact

      click_button('Сохранить')

      sleep(1)

      expect(Order.last.contact_person['name']).to eq(new_contact)
    end
  end

  context 'close order', js: true do
    let!(:order) { create(:order) }

    before(:each) do
      expect(Order.last.state).to eq('published')
      sign_in(order.profile.user)
      find('#production-site-list').click
      find('#first_pr_site').click
      click_link(order.title)
      sleep(1)
      find('.enjoyhint_skip_btn').click
      click_link('Закрыть')
      sleep(1)
    end

    scenario 'close!' do
      click_button('Да')

      sleep(1)

      expect(Order.last.state).to eq('completed')
    end

    scenario 'dont closed' do
      click_button('Нет')

      sleep(1)

      expect(Order.last.state).to eq('published')
    end
  end

  context 'add employ to order' do
    let!(:order) { create(:order) }

    scenario 'add!', js: true do
      sign_in(order.profile.user)
      find('#production-site-list').click
      find('#first_pr_site').click

      click_link(order.title)
      sleep(1)

      find('.enjoyhint_skip_btn').click
      find('.add-personal').click
      sleep(1)

      page.execute_script("$('#order_number_additional_employees').val('1')")

      click_button('Добавить')

      sleep(1)

      find('.enjoyhint_skip_btn').click
      click_on('Оплатить')
      sleep(1)

      expect(Order.last.number_of_employees).to eq(order.number_of_employees + 1)
      expect(page).to have_content("Осталось #{Order.last.number_of_employees} человек")
    end

    scenario "cant add, more that balance", js: true do
      sign_in(order.profile.user)
      find('#production-site-list').click
      find('#first_pr_site').click

      click_link(order.title)
      sleep(1)

      find('.enjoyhint_skip_btn').click
      find('.add-personal').click
      sleep(1)

      page.execute_script("$('#order_number_additional_employees').val('999')")

      click_button('Добавить')

      sleep(1)

      find('.enjoyhint_skip_btn').click
      expect(page).to have_link('Пополнить баланс')
      count_order = Order.last.customer_price * 999
      expect(count_order).to be > Balance.last.amount
    end
  end

  context 'reopen order' do
    let!(:order) { create(:order, :compleated) }

    scenario "reopen!", js: true do
      sign_in(order.profile.user)
      find('#production-site-list').click
      find('#first_pr_site').click
      sleep(1)
      find('.enjoyhint_skip_btn').click
      sleep(1)

      find("div[data-target='finished']").click
      sleep(1)

      click_link(order.title)
      sleep(1)
      find('.enjoyhint_skip_btn').click

      find('.add-personal').click
      sleep(1)

      page.execute_script("$('#order_number_additional_employees').val('1')")
      click_button('Добавить')
      sleep(1)

      find('.enjoyhint_skip_btn').click
      click_on('Оплатить')
      sleep(1)

      expect(Order.last.state).to eq('published')
    end
  end
end