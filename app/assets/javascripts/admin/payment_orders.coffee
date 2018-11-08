$(document).on('submit', '.payment_orders_form', (event) ->
  func = ->
    $('input[name=find]').prop('disabled', false)
    $('input[name=download]').prop('disabled', false)
  setTimeout(func, 2000)
)
