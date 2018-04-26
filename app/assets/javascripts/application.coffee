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
#= require_tree .

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

@inner_ajaxer = (url, data, ajtype = 'post') ->
  $.ajax
    dataType: 'script'
    type: ajtype
    url: url
    data: data
  return

@ajax_client = (url, data, success_func, error_func, method = 'get', data_type = 'html') ->
  $.ajax
    method: method
    url: url
    data: data
    dataType: data_type
    success: success_func
    error: error_func
  return

@hash_scan = (element, list) ->
  if typeof list != 'undefined'
    if typeof list == 'object'
      for key of list
        if typeof res == 'undefined'
          res = if key == element then list[key] else hash_scan(element, list[key])
  res

@flattenObject = (ob) ->
  toReturn = {}
  for i of ob
    if !ob.hasOwnProperty(i)
      continue
    if typeof ob[i] == 'object'
      flatObject = flattenObject(ob[i])
      for x of flatObject
        if !flatObject.hasOwnProperty(x)
          continue
        toReturn[i + '.' + x] = flatObject[x]
    else
      toReturn[i] = ob[i]
  toReturn

@init_mdb = () ->
  $('select.mdb-select:not(.initialized)').material_select()
  $('[data-toggle="tooltip"]').tooltip()
  $('.button-collapse').sideNav()
  sideNavScrollbar = document.querySelector('.custom-scrollbar')
  Ps.initialize(sideNavScrollbar)
  toastr.options = {
    "closeButton": true,
    "progressBar": true,
    "positionClass": "toast-top-full-width",
    "timeOut": 5000
  }
  $('.min-chart#chart-sales').easyPieChart
    barColor: '#4caf50'
    onStep: (from, to, percent) ->
      $(@el).find('.percent').text Math.round(percent)
      return

$(document).ready ->
  init_mdb()

  $(document).on 'focusin', '*[data-autocomplete-on]', ->
    add_autocomplete $(this)
    return

  $(document).on 'click', '.datepicker', ->
    $(this).next().pickadate(pickadate_rus_dfs).trigger('click');
    return

  $(document).on 'focusin', '*[data-mask-on="mobile"]', ->
    $(this).inputmask
      mask: '999 999 9999'
      showMaskOnFocus: false
    return

  $(document).on 'focusin', '*[data-mask-on="date"]', ->
    $(this).inputmask
      mask: '99.99.9999'
      showMaskOnFocus: false
    return

  $(document).on 'click', '[data-modal-destroy]', ->
    operand = $(this).data('modal-destroy')
    $('#' + operand).remove()
    return

  console.log('loaded!')

#  $(document).on 'click', '[data-skin]', ->
#    OldCls = document.querySelector('body').className.match(/\w*-skin/,)
#    document.querySelector('body').classList.remove(OldCls)
#    document.querySelector('body').classList.add(this.dataset.skin)

