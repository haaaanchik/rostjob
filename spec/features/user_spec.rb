require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  context 'registration new user' do
    scenario 'registration new customer' do
      expect(Profile.count).to eq(0)
      visit new_customer_path

      fill_in 'E-Mail', with: 'test@mail.com'

      click_button 'Нанять персонал'
      expect(page).to have_content 'Cпасибо за регистрацию.'

      sleep(1)
      Profile.last.customer? == true
      Profile.last.company.persisted? == true
      Profile.last.balance.persisted? == true
      Profile.last.company.accounts.any? == true
    end

    scenario 'registration new contractor' do
      visit new_contractor_path

      fill_in 'E-Mail', with: 'test@mail.com'

      click_button 'Регистрироваться как фрилансер'
      expect(page).to have_content 'Cпасибо за регистрацию.'
    end
  end

  # context 'login to system' do
  #   let!(:user) { create(:customer, :new)}
  #   let(:company) { attributes_for(:company) }
  #   let(:account) { attributes_for(:account) }

    # scenario 'loginning to the system' do
    #   visit root_path
    #   click_link('Вход')
    #   expect(page).to have_current_path(login_path)
    #   expect(page).to have_content 'Вход'
    #   fill_in 'E-Mail', with: user.email
    #   fill_in 'Пароль', with: user.password

    #   click_button 'Вход'
    #   fill_in 'user_password',              with: user.password
    #   fill_in 'user_password_confirmation', with: user.password
    #   click_button 'Сохранить'

    #   fill_in 'profile_company_attributes_short_name',   with: company[:short_name]
    #   fill_in "profile_company_attributes_name",	       with: company[:name]
    #   fill_in "profile_company_attributes_address",	     with: company[:address]
    #   fill_in "profile_company_attributes_mail_address", with: company[:address]
    #   fill_in "profile_company_attributes_phone",	       with: company[:phone]
    #   fill_in "profile_company_attributes_fax",	         with: company[:fax]
    #   fill_in "profile_company_attributes_email",	       with: company[:email]
    #   fill_in "profile_company_attributes_ogrn",	       with: company[:ogrn]
    #   fill_in "profile_company_attributes_inn",	         with: company[:inn]
    #   fill_in "profile_company_attributes_kpp",	         with: company[:kpp]
    #   fill_in "profile_company_attributes_director",	   with: company[:director]
    #   fill_in "profile_company_attributes_acts_on",	     with: company[:acts_on]

    #   fill_in 'Наименование банка',     with: account[:bank]
    #   fill_in 'Адрес банка',            with: account[:bank_address]
    #   fill_in 'БИК',                    with: account[:bic]
    #   fill_in 'ИНН банка',              with: account[:inn]
    #   fill_in 'КПП банка',              with: account[:kpp]
    #   fill_in 'Расчётный счёт',         with: account[:account_number]
    #   fill_in 'Корреспондентский счёт', with: account[:corr_account]
    #   click_button 'Сохранить'

    #   expect(page).to have_content 'Главная'
    #   expect(page).to have_current_path(root_path)
    # end
  # end

  context 'edit uset profile' do
    let!(:customer) { create(:customer) }

    before(:each) do
      sign_in(customer)
      click_link 'Редактировать'
    end

    scenario 'edit! profile' do
      fill_in 'Наименование организации', with: 'changed user name'

      click_button 'Сохранить'

      expect(page).to have_content 'changed user name'
      expect(User.last.full_name).to eq('changed user name')
    end

    scenario 'cant update password without current_password' do
      within('#edit_user') do
        fill_in 'user_password',              with: '1234554321'
        fill_in 'user_password_confirmation', with: '1234554321'

        click_button 'Сохранить'
      end

      current_path.should_not == root_path
      expect(page).to have_content('не может быть пустым')
    end
  end
end