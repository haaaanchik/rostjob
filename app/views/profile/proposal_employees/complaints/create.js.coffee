<% if @status == 'success' %>
toastr.success('Данные успешно сохранены')
$('#proposal_employee_' + <%= @proposal_employee.id %> ).addClass('red lighten-5')
normal_modal_close('formModalMyComplaints')
window.location.replace("<%= profile_candidate_path(@proposal_employee) %>")
<% else %>
toastr.error('<%= j @text %>', 'Неудача!')
<% end %>
