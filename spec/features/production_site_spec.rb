require 'rails_helper'

RSpec.feature 'Production Site', type: :feature do
  context 'create new production_site' do
    let!(:production_site) { attributes_for(:production_site) }

    scenario 'create new production_site', js: true do
      sign_in(:customer)

      find('#production-site-list').click
      expect(page).to have_current_path(profile_production_sites_path)
      click_link('Добавить площадку')

      sleep(1)
      within('#production_site_form') do
        fill_in 'production_site_title', with: production_site[:title]
        fill_in 'production_site_city', with: production_site[:city]
        fill_in 'production_site_info', with: production_site[:info]
        fill_in 'production_site_phones', with: production_site[:phones]

        click_button 'Сохранить'
      end
      sleep(1)

      expect(page).to have_content production_site[:title]
    end
  end

  context 'edit production_site' do
    let!(:user) { create(:customer, :with_production_site) }

    scenario 'edit production_site', js: true do
      new_title = ProductionSite.first.title + ' update title'
      sign_in(:customer, :with_production_site)

      find('#production-site-list').click

      click_link('Редактировать')
      sleep(1)

      within('#production_site_form') do
        fill_in 'production_site_title', with: new_title
        click_button 'Сохранить'
      end

      expect(page).to have_content new_title
    end
  end
end