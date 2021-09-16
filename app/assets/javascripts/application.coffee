#= require external/jquery-3.3.1.min
#= require jquery
#= require external/popper.min
#= require external/bootstrap
#= require external/jquery-ui.min
#= require external/mdb
#= require external/mdb.ru_RU
#= require external/jquery.inputmask.bundle.min
#= require rails-ujs
#= require jquery.turbolinks
#= require bot_phone
#= require pit_chat_widget
#= require turbolinks
#= require external/turbolinks-compatibility
#= require external/jquery.raty
#= require external/bootstrap-datepicker
#= require external/bootstrap-datepicker.ru.min
#= require tinymce
#= require jquery.inputmask
#= require data-confirm-modal
#= require select2
#= require select2_locale_ru
#= require order
#= require production_sites
# require jquery.inputmask.extensions
# require jquery.inputmask.numeric.extensions
# require jquery.inputmask.date.extensions
#= require action_cable
#= require pre_publish
#= require external/fullcalendar
#= require external/fullcalendar/daygrid.min
#= require lightbox
#= require admin_menu
#= require app
#= require_tree .

@scroll_to_bottom = (element) ->
  if element
    element.scrollTop = element.scrollHeight - element.getBoundingClientRect().height

@bootstrapClearButton = () ->
  $('.position-relative :input').on('keydown focus', () ->
    if ($(this).val().length > 0)
      $(this).nextAll('.form-clear').removeClass('d-none')
  ).on('keydown keyup blur', () ->
    if ($(this).val().length == 0)
      $(this).nextAll('.form-clear').addClass('d-none')
  )
  $('.form-clear').on('click', () ->
    $(this).addClass('d-none').prevAll(':input').val('')
    $('[id$=search_form]').submit()
  )

bootstrapClearButton()

@ajax_client = (url, data, success_func, error_func, method = 'get', data_type = 'html') ->
  $.ajax
    method: method
    url: url
    data: data
    dataType: data_type
    success: success_func
    error: error_func
  return

@add_autocomplete = (operand) ->
  if !operand.data('auto-active')
    operand.autocomplete(
      source: operand.data('auto-url')
      minLength: 1
      select: (event, ui) ->
        if operand.data('auto-select')
          window[operand.data('auto-select')].call null, ui.item
        operand[0].value = null
        if !operand.data('auto-add-text')
          false
    ).data('ui-autocomplete')._renderItem = (ul, item) ->
      $('<li></li>').data('item.autocomplete', item)
        .append($('<a></a>').html(item.label)).appendTo(ul)

  operand.data 'auto-active', true
  return

@normal_modal_close = (id) ->
  $('body').css('overflow', 'auto')
  operand = $('#' + id)
  operand.modal('hide')
  setTimeout (->
    operand.remove()
  ), 300
  return

@normal_modal_open = (id, html) ->
  $('#' + id).remove()
  setTimeout (->
    $("#modal_append").append html
    $('[data-toggle="popover"]').popover('enable')
    $('#' + id).modal()
    # $('body').css('overflow', 'hidden')
  ), 400
  return

@init_mdb = () ->
  new WOW().init()
  toastr.options = {
    "closeButton": true,
    "positionClass": "custom-toast-top-right",
    "timeOut": 5000
  }
  $('select.mdb-select:not(.initialized)').material_select()
  $('[data-toggle="tooltip"]').tooltip()
  $(window).scroll ->
    if $(this).scrollTop() > 50
      $('[href="#top-section"]').fadeIn('slow')
    else
      $('[href="#top-section"]').fadeOut('slow')
    return

@initTinymce = () ->
  tinyMCE.init({
    selector: 'textarea.tinymce'
    branding: false
    language: 'ru_RU'
    elementpath: false
    statusbar: false
    menubar: false
    toolbar: 'undo redo | bold italic underline | indent outdent | numlist bullist'
    plugins: "lists"
    forced_root_block: false
  })

$(document).ready ->
  $('select#simple-example').select2({ width: '66%' })
  scroll_to_bottom($('.ticket-messages')[0])
  init_mdb()
  initTinymce()
  $(document).on 'focusin', '*[data-mask-on="date"]', ->
    $(this).datepicker({
      format: 'dd.mm.yyyy',
      autoclose: true,
      todayHighlight: true,
      language: "ru"
    }).inputmask
      mask: '99.99.9999'
      showMaskOnFocus: false
    return

  $(document).on 'focusin', '*[data-autocomplete-on]', ->
    add_autocomplete $(this)
    return

  $('[data-redirect_modal="open"]').modal()

  $(document).on('ajax:error', '[data-remote=true]', (event) ->
    data = event.detail[0]
    if data.validate
      show_validation_errors(data.data)
  )

  $(document).on('focusin', '.is-invalid', (event) ->
    $(event.currentTarget).removeClass('is-invalid')
  )

  $(document).on "turbolinks:load", ->
    $('input[type=tel]').inputmask("+*(999)-999-99-99")
    $('.form-control#profile_company_attributes_ogrn').inputmask("9999999999999")
    $('.form-control#profile_company_attributes_kpp').inputmask("999999999")
    
  $('[data-toggle="popover"]').popover('enable')
