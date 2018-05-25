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
#= require jquery.raty
#= require froala_editor.min.js
#= require languages/ru.js
#= require plugins/lists.min.js
#= require plugins/paragraph_format.min.js
#= require plugins/code_view.min.js
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

@init_mdb = () ->
  new WOW().init()
  $('select.mdb-select:not(.initialized)').material_select()
  $(window).scroll ->
    if $(this).scrollTop() > 50
      $('[href="#top-section"]').fadeIn('slow')
    else
      $('[href="#top-section"]').fadeOut('slow')
    return

$(document).ready ->
  init_mdb()
  $('#order_description').froalaEditor({
    iconsTemplate: 'font_awesome_5',
    language: 'ru',
    toolbarButtons: ['undo', 'redo' , '|', 'paragraphFormat', 'bold', 'italic', 'underline',
    'outdent', 'indent', 'clearFormatting', 'formatOL', 'formatUL', 'html']
  })

  $(document).on 'focusin', '*[data-autocomplete-on]', ->
    add_autocomplete $(this)
    return

  $('[data-redirect_modal="open"]').modal()
