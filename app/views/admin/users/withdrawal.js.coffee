<% if @result.success? %>
  $('td[data-user-id=<%= @contractor.user.id %>]').text('счет выписан')
  toastr.success('Счёт выписан')
<% else %>
  toastr.error('Не удалось выписать счет, пожалуйста проверьте счет')
<% end %>