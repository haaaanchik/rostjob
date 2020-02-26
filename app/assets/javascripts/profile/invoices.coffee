class Invoices
  @init: ->
    @bind()

  @bind: ->
    $('.personalAccount_operations button').on 'click', @openPersonalOperations
    $('.allAccounts_button button').on 'click', @openMoreInvoices

  @openPersonalOperations: ->
    $('.personalAccount_open').toggleClass('close')

  @openMoreInvoices: ->
    $('.allAccounts_open').toggleClass('close')

$(document).on 'turbolinks:load', ->
  Invoices.init()