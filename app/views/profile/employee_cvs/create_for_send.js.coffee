<% if @status == 'success' %>
toastr.success('Анкета успешно отправлена')
$('#empl-form').modal('hide')
<% end %>
