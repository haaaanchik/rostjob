class DisableDoubleClick
  @init: ->
    $("[data-disable-bouble-click='true']").bind 'ajax:beforeSend', ->
      $(this).prop('disabled', true)
    
    $("[data-disable-bouble-click='true']").bind 'ajax:complete', ->
      $(this).prop('disabled', false)

$(document).on 'turbolinks:load', ->
  DisableDoubleClick.init()