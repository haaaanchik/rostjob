console.log('-----------', <% @message %>)

<% if @status == 'success' %>
<% rdr = render partial: 'profile/tickets/messages/message', locals: { message: @message } %>
$('.messages.custom-scroll').append('<%= j rdr %>')
block = $('.messages.custom-scroll')[0]
lastMessage = $('.messages.custom-scroll .message:last()')[0]
block.scrollTop = block.scrollHeight - lastMessage.scrollHeight
<% end %>