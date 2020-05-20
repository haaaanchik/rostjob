# require 'rails_helper'

# RSpec.feature 'Order', type: :feature do
#   context 'create new order' do
#     let!(:user) { create(:customer, :with_production_site) }
#     let!(:price_group) { create(:price_group) }
#     let(:position) { price_group.positions.first }

#     scenario 'create new order', js: true do
#       visit login_path

#       fill_in 'E-Mail', with: user.email
#       fill_in 'Пароль', with: user.password
#       click_button 'Вход'

#       sleep(1)
#       find('.enjoyhint_skip_btn').click

#       find('#production-site-list').click
#       sleep(1)
#       find('.enjoyhint_skip_btn').click

#       click_link('Добавить заявку')
      
#       binding.pry
      
#       within('#order_template_form') do
#         fill_in 'order_template_position_search', with: position.title
#         find('#order_template_position_search').click
#         save_and_open_page
#         fill_in 'order_template_skill', with: 'мастер'
#       end
      
#       click_button('Далее')
      
#       save_and_open_page
#     end
#   end
# end