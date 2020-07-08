require 'rails_helper'

RSpec.feature 'Work with invoice', type: :feature do
  # context 'create invoice' do
  #   let!(:customer) { create(:customer) }

  #   before(:each) do
  #     sign_in(customer)
  #     expect(page).to have_link('Пополнить', href: profile_invoices_path)
  #     visit profile_invoices_path
  #   end

    # scenario 'cant create invoice with zero amount', js: true do
    #   find('.enjoyhint_skip_btn').click
    #   save_and_open_page
    #   fill_in 'Сумма',	with: '0'
    #   expect(page).to have_button('Выставить счёт')
      
    #   # within('.allAccounts_open_table') do
    #   #   expect(page).not_to have_context('0')
    #   # end
    # end
    ##NEED API_KEY FOR TESTING
    # scenario 'cant create invoice with zero amount', js: true do
    #   ActiveRecord::Base.connection
    #                     .execute('insert into invoice_number_seqs(invoice_number) values(0)')
    #   find('.enjoyhint_skip_btn').click
    #   fill_in 'replenishAccountSumm',	with: 1111

    #   click_on('Выставить счет')
    # end
  # end
end