class RostJob.AdminOrdersShow
  @init: ->
    @bind()
    showAdvTextInput() unless $('.form-control-checkbox').is(':checked')

  @bind: ->
    $('#order_advertising').on 'click', showAdvTextInput

  showAdvTextInput = ->
    $('.adv-text-label, .adv-text-input').slideToggle(700)

class RostJob.AdminOrdersEdit extends RostJob.AdminOrdersShow