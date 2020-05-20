require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  context 'registration new user' do
    scenario 'registration new customer' do
      visit new_customer_path

      within('#new_user') do
        fill_in 'E-Mail', with: 'test@mail.com'
      end

      click_button 'Нанять персонал'
      expect(page).to have_content 'Cпасибо за регистрацию.'
    end

    scenario 'registration new contractor' do
      visit new_contractor_path

      within('#new_user') do
        fill_in 'E-Mail', with: 'test@mail.com'
      end

      click_button 'Регистрироваться как фрилансер'
      expect(page).to have_content 'Cпасибо за регистрацию.'
    end
  end

  context 'login to system' do
    let!(:user) { create(:customer, :new)}
    let(:company) { attributes_for(:company) }

    scenario 'loginning to the system' do
      visit root_path
      click_link('Вход')
      expect(page).to have_current_path(login_path)
      expect(page).to have_content 'Вход'
      fill_in 'E-Mail', with: user.email
      fill_in 'Пароль', with: user.password

      click_button 'Вход'

      fill_in 'user_password', with: user.password
      fill_in 'user_password_confirmation', with: user.password
      click_button 'Сохранить'

      fill_in 'profile_company_attributes_short_name', with: company[:short_name]
      fill_in "profile_company_attributes_name",	with: company[:name]
      fill_in "profile_company_attributes_address",	with: company[:address]
      fill_in "profile_company_attributes_mail_address",	with: company[:address]
      fill_in "profile_company_attributes_phone",	with: company[:phone]
      fill_in "profile_company_attributes_fax",	with: company[:fax]
      fill_in "profile_company_attributes_email",	with: company[:email]
      fill_in "profile_company_attributes_ogrn",	with: company[:ogrn]
      fill_in "profile_company_attributes_inn",	with: company[:inn]
      fill_in "profile_company_attributes_kpp",	with: company[:kpp]
      fill_in "profile_company_attributes_director",	with: company[:director]
      fill_in "profile_company_attributes_acts_on",	with: company[:acts_on]
      click_button 'Сохранить'
 
      expect(page).to have_content 'Главная'
      expect(page).to have_current_path(root_path)
    end
  end
end