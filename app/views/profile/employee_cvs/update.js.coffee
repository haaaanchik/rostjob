<% if @status == 'success' %>
toastr.success('', 'Анкета успешна обновлена')
location.reload()
<% end %>