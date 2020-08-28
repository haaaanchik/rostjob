<% if @status == 'success' %>
toastr.success('Анкета успешно отправлена')
$('#empl-form').modal('hide')
<% else %>
toastr.error('Такая анкета уже существует.')
<% end %>
