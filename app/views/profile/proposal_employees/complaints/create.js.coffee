<% if @status == 'success' %>
toastr.success('Данные успешно сохранены')
$('#proposal_employee_' + <%= @proposal_employee.id %> ).addClass('red lighten-5')
normal_modal_close('formModalMyComplaints')
<% else %>
toastr.error('<%= j @text %>', 'Неудача!')
<% end %>
