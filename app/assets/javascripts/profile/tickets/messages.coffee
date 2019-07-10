$(document).on('ajax:success', '#ticket_message_form', (event) ->
  message = event.detail[2].response
  messages = $('.ticket-messages')
  messages.append(message)
  scroll_to_bottom(messages[0])
  $('#message_text').val('')
)
