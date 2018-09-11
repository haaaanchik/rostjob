@apply_company_dadata = (items) ->
  $('#company_name').val items.name
  $('#company_short_name').val items.short_name
  $('#company_address').val items.address
  $('#company_inn').val items.inn
  $('#company_kpp').val items.kpp
  $('#company_ogrn').val items.ogrn
  $('#company_director').val items.director
