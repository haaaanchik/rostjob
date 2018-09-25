@profile_company_dadata = (items) ->
  $('#profile_company_attributes_name').val items.name
  $('#profile_company_attributes_short_name').val items.short_name
  $('#profile_company_attributes_address').val items.address
  $('#profile_company_attributes_inn').val items.inn
  $('#profile_company_attributes_kpp').val items.kpp
  $('#profile_company_attributes_ogrn').val items.ogrn
  $('#profile_company_attributes_director').val items.director

@profile_company_bank_dadata = (items) ->
  $('#profile_company_attributes_accounts_attributes_0_bic').val items.bic
  $('#profile_company_attributes_accounts_attributes_0_corr_account').val items.corr_account
  $('#profile_company_attributes_accounts_attributes_0_bank').val items.bank
  $('#profile_company_attributes_accounts_attributes_0_bank_address').val items.bank_address
