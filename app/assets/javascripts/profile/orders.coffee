$ ->
  $('label[for=order_accepted]').on('click', (event) ->
    element = $('#order_accepted')
    checked = element.prop('checked')
    if checked == false
      $('.order-submit-button').removeClass('disabled')
    else
      $('.order-submit-button').addClass('disabled')
  )
