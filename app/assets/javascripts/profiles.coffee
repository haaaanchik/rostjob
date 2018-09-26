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

$(document).on('click', '[for^=profile_profile_type]', (event) ->
  profile_type = $(this).data('profile-type')
  if profile_type == 'customer'
    set_legal_form_to_company()
    disable_legal_form()
    show_company_interface()
  else
    enable_legal_form()
)

$(document).on('click', '[for^=profile_legal_form]', (event) ->
  legal_form = $(this).data('legal-form')
  console.log legal_form
  if legal_form == 'private_person'
    show_private_person_interface()
  else
    show_company_interface()
)

@show_company_interface = ->
  show_company_search()
  show_company_fields()

@show_private_person_interface = ->
  hide_company_search()
  hide_company_fields()
  show_private_person_fields()

@hide_company_fields = ->
  fields = $(".company-field")
  fields.hide()
  inputs = fields.find('input')
  inputs.prop('disabled', true)

@show_company_fields = ->
  fields = $(".company-field")
  inputs = fields.find('input')
  inputs.prop('disabled', false)
  label = fields.find('[data-name]')
  name = label.data('name')
  label.html(name)
  set_company_header()
  fields.show()

@show_private_person_fields = ->
  fields = $(".private-person-field")
  inputs = fields.find('input')
  inputs.prop('disabled', false)
  label = fields.find('[data-full-name]')
  full_name = label.data('full-name')
  label.html(full_name)
  set_private_person_header()
  fields.show()

@hide_company_search = ->
  $('.company-search').hide()

@show_company_search = ->
  $('.company-search').show()

@set_private_person_header = ->
  header = $('[data-private-person-header]')
  header_text = header.data('private-person-header')
  header.text(header_text)

@set_company_header = ->
  header = $('[data-company-header]')
  header_text = header.data('company-header')
  header.text(header_text)

@disable_legal_form = ->
  $('[id^=profile_legal_form]').prop('disabled', true)
  $('[for^=profile_legal_form]').addClass('disabled')

@enable_legal_form = ->
  $('[id^=profile_legal_form]').prop('disabled', false)
  $('[for^=profile_legal_form]').removeClass('disabled')

@set_legal_form_to_company = ->
  $('[id=profile_legal_form_company]').prop('checked', true)
