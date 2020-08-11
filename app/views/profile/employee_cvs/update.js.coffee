<% if @status == 'success' %>
toastr.success('', 'Анкета успешно обновлена!')
location.reload()
<% end %>