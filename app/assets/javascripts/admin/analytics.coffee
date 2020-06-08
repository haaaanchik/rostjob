class Analytics
  @init: ->
    @dataPickerInit()
    @bind()

  @bind: ->
    $('#orders_info_page').on 'change', '#orders_info_search select', @doSearch
    $('#orders_info_page').on 'keyup', '#q_user_full_name_or_title_cont', @doSearch
    $('#orders_info_page').on 'change', '#date-picker-date', @doSearch

  @dataPickerInit: ->
    $('.datepicker').pickadate({
      formatSubmit: false,
      dateFormat: "yy-mm-dd"
    })
  
  @doSearch: (e)->
    if (e.keyCode == 13 || e.type == 'change')
      $('#orders_info_search').submit()

$(document).on 'turbolinks:load', ->
  Analytics.init()