@apply_bank_dadata = (items) ->
  $('#company_accounts_attributes_0_bic').val items.bic
  $('#company_accounts_attributes_0_corr_account').val items.corr_account
  $('#company_accounts_attributes_0_bank').val items.bank
  $('#company_accounts_attributes_0_bank_address').val items.bank_address
