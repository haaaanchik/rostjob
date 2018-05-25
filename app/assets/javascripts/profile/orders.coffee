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
    target = $(event.relatedTarget)
    order_id = target.data('order_id')
    proposal_id = target.data('proposal_id')
    recruiter_id = target.data('recruiter_id')
    modal = $(this)
    # modal.find('.modal-title').text('New message to ' + profile_id)
    # modal.find('.modal-title').text('New message to ' + recipient)
    # modal.find('.modal-body input').val(recipient)
  )

@apply_position = (item) ->
  html = "<p><strong>Типовые обязанности:</strong><br />#{item.duties}</p>"
  $('#order_description').froalaEditor('html.insert', html, true)
