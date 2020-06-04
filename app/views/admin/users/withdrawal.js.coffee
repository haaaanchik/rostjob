<% if @result.success? %>
  $('td[data-user-id=<%= @contractor.user.id %>]').text('счет выписан')
  toastr.success('Задача для выписки счета успешно создана')
<% else %>
  toastr.error('Не удалось выписать счет, пожалуйста проверьте счет')
<% end %>