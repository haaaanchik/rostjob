$ ->
  $('label[for=order_accepted]').on('click', (event) ->
    element = $('#order_accepted')
    checked = element.prop('checked')
    if checked == false
      $('.order-submit-button').removeClass('disabled')
    else
      $('.order-submit-button').addClass('disabled')
  )

  $('#executorModal').on('show.bs.modal', (event) ->
    link = $(event.relatedTarget)
    profile_id = link.data('profile_if')
    modal = $(this)
    # modal.find('.modal-title').text('New message to ' + recipient)
    # modal.find('.modal-body input').val(recipient)
  )
