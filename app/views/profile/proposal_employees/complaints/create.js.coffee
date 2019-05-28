<% if @status == 'success' %>
toastr.success('Данные успешно сохранены')
$('#proposal_employee_' + <%= @proposal_employee.id %> ).addClass('red lighten-5')
normal_modal_close('formModalMyComplaints')
<% if @current_profile.customer? %>
window.location.replace("<%= profile_candidate_path(@proposal_employee) %>")
<% end %>
<% else %>
toastr.error('<%= j @text %>', 'Неудача!')
<% end %>
