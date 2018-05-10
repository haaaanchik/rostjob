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

$(document).ready ->
  new WOW().init()
  $('.mdb-select').material_select()
  $(document).on 'focusin', '*[data-autocomplete-on]', ->
    add_autocomplete $(this)
