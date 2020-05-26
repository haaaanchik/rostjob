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

      fill_in 'contact-face', with: order[:contact_person][:contact_name]
      fill_in 'contact-face-number', with: order[:contact_person][:contact_phone]

      page.execute_script("tinyMCE.get('order_template_other_info_remark').setContent('TEXT')")
      find_by_id('send').click
      sleep(1)

      find_by_id('order_publish').click

      expect(Order.count).to eq(1)
    end
  end

  # context 'edit order' do
  #   let!(:customer) { create(:customer, :with_production_site) }
  #   let!(:price_group) { create(:price_group) }
  #   let!(:order) { create(:order, profile: customer.profile, production_site: customer.profile.production_sites.first, position: price_group.positions.first)}
  #   let(:new_order_skill) { "#{order.skill} 111" }

  #   scenario 'edit order' do
  #     sign_in(customer)
  #     find('#production-site-list').click
  #     find('#first_pr_site').click
  #     click_link(order.title)
  #     click_link('Редактировать')

  #     fill_in 'Квалификация', with: new_order_skill
  #     click_link('Далее')

  #     click_button('Далее')
  #     fill_in 'contact-face', with: order.contact_person['contact_name']
  #     fill_in 'contact-face-number', with: order.contact_person['contact_phone']
  #     click_button('Сохранить')

  #     expect(Order.last.skill).to eq(new_order_skill)
  #   end
  # end

  context 'close order', js: true do
    let!(:customer) { create(:customer, :with_production_site) }
    let(:price_group) { create(:price_group) }
    let!(:order) { create(:order, profile: customer.profile, production_site: customer.profile.production_sites.first, position: price_group.positions.first)}

    before(:each) do
      expect(customer.profile.orders.last.state).to eq('published')
      sign_in(customer)
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
      expect(customer.profile.orders.last.state).to eq('completed')
    end

    scenario 'dont closed' do
      click_button('Нет')
      expect(customer.profile.orders.last.state).to eq('published')
    end
  end

  context 'close order', js: true do
    let!(:customer) { create(:customer, :with_production_site) }
    let(:price_group) { create(:price_group) }
    let!(:order) { create(:order, profile: customer.profile, production_site: customer.profile.production_sites.first, position: price_group.positions.first)}

    scenario 'add emp' do
      sign_in(customer)
      find('#production-site-list').click
      find('#first_pr_site').click
      click_link(order.title)
      sleep(1)
      find('.enjoyhint_skip_btn').click
      find('.add-personal').click
      sleep(1)

      # page.execute_script("$('#order_number_additional_employees').val('1')")
      # find('#order_number_additional_employees').set('1')
      # click_button('Добавить')

      # save_and_open_page
      # expect(page).to have_content('Осталось 2 человек')
    end
  end
end