$ ->
  $('.send-message-form').on('ajax:success', (event) ->
    message = event.detail[2].response
    $('.messages').append(message)
    $("[name='message[text]'").val('')
  )

  $('.send-message-form').on('ajax:error', (event) ->
  )
