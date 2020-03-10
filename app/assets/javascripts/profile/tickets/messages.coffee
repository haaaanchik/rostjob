class Messages
  @init: ->
    @initScroll() if $('#chat-room').length
    @bind()

  @initScroll: ->
    block = $('.messages.custom-scroll')[0]
    lastMessage = $('.messages.custom-scroll .message:last()')[0]
    block.scrollTop = block.scrollHeight - lastMessage.scrollHeight

  @bind: ->
    $('#message_text').on 'keypress', @sendSubmit

  @sendSubmit: (e) ->
    if e.which == 13
      $(this).parents('form').submit()

$(document).on 'turbolinks:load', ->
  Messages.init()

$(document).on('ajax:success', '#ticket_message_form', (event) ->
  message = event.detail[2].response
  messages = $('.ticket-messages')
  messages.append(message)
  scroll_to_bottom(messages[0])
  $('#message_text').val('')
)
