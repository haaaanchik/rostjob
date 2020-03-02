class Invoices
  @init: ->
    @bind()

  @bind: ->
    $('.personalAccount_operations button').on 'click', @openPersonalOperations

  @openPersonalOperations: ->
    $('.personalAccount_open').fadeToggle(600)
    $('#operations i.fa').toggleClass('fa-rotate-270 fa-rotate-90')

$(document).on 'turbolinks:load', ->
  Invoices.init()