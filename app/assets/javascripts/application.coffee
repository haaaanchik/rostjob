#= require external/jquery-3.3.1.min
#= require external/popper.min
#= require external/bootstrap
#= require external/jquery-ui.min
#= require external/mdb
#= require external/mdb.ru_RU
#= require external/jquery.inputmask.bundle.min
#= require rails-ujs
#= require jquery.turbolinks
#= require turbolinks
#= require external/turbolinks-compatibility
#= require external/jquery.raty
#= require tinymce
#= require_tree .

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
    $('body').css('overflow', 'hidden')
  ), 100
  return

@init_mdb = () ->
  new WOW().init()
  toastr.options = {
    "closeButton": true,
    "positionClass": "toast-top-right",
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

$(document).ready ->
  init_mdb()
  tinyMCE.init({
    selector: 'textarea.tinymce'
    branding: false
    language: 'ru_RU'
    elementpath: false
    statusbar: false
    menubar: false
    toolbar: 'undo redo | bold italic underline | indent outdent | numlist bullist'
    plugins: "lists"
  })

  $(document).on 'focusin', '*[data-autocomplete-on]', ->
    add_autocomplete $(this)
    return

  $('[data-redirect_modal="open"]').modal()

  $(document).on('ajax:success', '[data-remote=true]', (event) ->
    data = event.detail[0]
    console.log(data)
    if data.validate
      show_validation_errors(data.data)
  )

  $(document).on('focusin', '.is-invalid', (event) ->
    console.log 'Focus in!'
    $(event.currentTarget).removeClass('is-invalid')
  )
