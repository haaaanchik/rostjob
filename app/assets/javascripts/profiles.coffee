$(document).on('change', '#free_manager', (event) ->
  element = $(event.target)
  set_free_url = element.data('set-free-url')
  unset_free_url = element.data('unset-free-url')
  url = ''
  checked = element.prop('checked')
  if checked == true
    url = set_free_url
  else
    url = unset_free_url

  $.ajax({
    url: url
    method: 'PUT'
    indexValue: { checked: checked },
    success: success,
    error: error
  })
)

success = ->
  if this.indexValue.checked == true
    toastr.success('Принимаем звонки от бота')
  else
    toastr.warning('Не принимаем звонки от бота')

error = ->
  toastr.error('Ошибка! Не удалось выполнить действие')


@withdrawal_method_ip_dadata = (items) ->
  $('#withdrawal_method_ip_account_company_attributes_name').val items.name
  $('#withdrawal_method_ip_account_company_attributes_short_name').val items.short_name
  $('#withdrawal_method_ip_account_company_attributes_address').val items.address
  $('#withdrawal_method_ip_account_company_attributes_inn').val items.inn
  $('#withdrawal_method_ip_account_company_attributes_ogrn').val items.ogrn
  $('#withdrawal_method_ip_account_company_attributes_director').val items.director

@withdrawal_method_company_dadata = (items) ->
  $('#withdrawal_method_company_account_company_attributes_name').val items.name
  $('#withdrawal_method_company_account_company_attributes_short_name').val items.short_name
  $('#withdrawal_method_company_account_company_attributes_address').val items.address
  $('#withdrawal_method_company_account_company_attributes_inn').val items.inn
  $('#withdrawal_method_company_account_company_attributes_kpp').val items.kpp
  $('#withdrawal_method_company_account_company_attributes_ogrn').val items.ogrn
  $('#withdrawal_method_company_account_company_attributes_director').val items.director

@profile_company_dadata = (items) ->
  $('#profile_company_attributes_name').val items.name
  $('#profile_company_attributes_short_name').val items.short_name
  $('#profile_company_attributes_address').val items.address
  $('#profile_company_attributes_inn').val items.inn
  $('#profile_company_attributes_kpp').val items.kpp
  $('#profile_company_attributes_ogrn').val items.ogrn
  $('#profile_company_attributes_director').val items.director

@withdrawal_method_ip_bank_dadata = (items) ->
  $('#withdrawal_method_ip_account_company_attributes_accounts_attributes_0_bic').val items.bic
  $('#withdrawal_method_ip_account_company_attributes_accounts_attributes_0_corr_account').val items.corr_account
  $('#withdrawal_method_ip_account_company_attributes_accounts_attributes_0_bank').val items.bank
  $('#withdrawal_method_ip_account_company_attributes_accounts_attributes_0_bank_address').val items.bank_address

@withdrawal_method_private_person_bank_dadata = (items) ->
  $('#withdrawal_method_private_person_account_company_attributes_accounts_attributes_0_bic').val items.bic
  $('#withdrawal_method_private_person_account_company_attributes_accounts_attributes_0_corr_account').val items.corr_account
  $('#withdrawal_method_private_person_account_company_attributes_accounts_attributes_0_bank').val items.bank
  $('#withdrawal_method_private_person_account_company_attributes_accounts_attributes_0_bank_address').val items.bank_address

@withdrawal_method_company_bank_dadata = (items) ->
  $('#withdrawal_method_company_account_company_attributes_accounts_attributes_0_bic').val items.bic
  $('#withdrawal_method_company_account_company_attributes_accounts_attributes_0_corr_account').val items.corr_account
  $('#withdrawal_method_company_account_company_attributes_accounts_attributes_0_bank').val items.bank
  $('#withdrawal_method_company_account_company_attributes_accounts_attributes_0_bank_address').val items.bank_address

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
  $('.hidden-legal-form').val(legal_form)
  console.log legal_form
  if legal_form == 'private_person'
    show_private_person_interface()
  else
    show_company_interface()
)

@show_company_interface = ->
  show_company_search()
  show_company_fields()
  disable_account_inn_kpp()
  hide_tax_office_fields()

@show_private_person_interface = ->
  hide_company_search()
  hide_company_fields()
  show_private_person_fields()
  show_tax_office_fields()
  enable_account_inn_kpp()

@show_tax_office_fields = ->
  card = $('.tax-office')
  tax_office_fields = card.find('input')
  tax_office_fields.prop('disabled', false)
  card.removeClass('hide-me')

@hide_tax_office_fields = ->
  card = $('.tax-office')
  card.addClass('hide-me')
  tax_office_fields = card.find('input')
  tax_office_fields.prop('disabled', true)


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
  $('[id^=profile_legal_form][type!=hidden]').prop('disabled', true)
  $('[for^=profile_legal_form]').addClass('disabled')

@enable_legal_form = ->
  $('[id^=profile_legal_form]').prop('disabled', false)
  $('[for^=profile_legal_form]').removeClass('disabled')

@set_legal_form_to_company = ->
  $('[id=profile_legal_form_company]').prop('checked', true)
  $('.hidden-legal-form').val('company')

@enable_account_inn_kpp = ->
  $('.inn_kpp').removeClass('disabled')

@disable_account_inn_kpp = ->
  $('.inn_kpp').addClass('disabled')
