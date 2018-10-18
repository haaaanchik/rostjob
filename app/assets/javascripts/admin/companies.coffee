@apply_company_dadata = (items) ->
  $('#company_name').val items.name
  $('#company_short_name').val items.short_name
  $('#company_address').val items.address
  $('#company_inn').val items.inn
  $('#company_kpp').val items.kpp
  $('#company_ogrn').val items.ogrn
  $('#company_director').val items.director

@admin_company_ifns = (item) ->
  $('#company_tax_office_attributes_payment_name').val "#{item.payment_name} (#{item.name})"
  $('#company_tax_office_attributes_inn').val item.inn
  $('#company_tax_office_attributes_kpp').val item.kpp
  $('#company_tax_office_attributes_bank_name').val item.bank_name
  $('#company_tax_office_attributes_bank_bic').val item.bank_bic
  $('#company_tax_office_attributes_bank_account').val item.bank_account
  oktmo_arr = item.oktmo.split(',')
  oktmo_list = ''
  oktmo_arr.forEach (item, index, arr) ->
    oktmo_list += "<a class='dropdown-item'>#{item}</a>"
  $('.oktmo-list').html(oktmo_list)
  if oktmo_arr.length == 1
    $('#company_tax_office_attributes_oktmo').val oktmo_arr[0]
  else
    $('#company_tax_office_attributes_oktmo').val ''

$('.oktmo-list').on('click', '.dropdown-item', (event) ->
  item = $(event.currentTarget).text()
  $('#company_tax_office_attributes_oktmo').val item
)
