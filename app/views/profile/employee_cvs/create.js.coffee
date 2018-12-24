<% if @status == 'success' %>
<% rdr = render partial: 'profile/employee_cvs/employee_cv',
 object: @employee_cv %>
$('#candidates_list').prepend('<%= j rdr %>')
toastr.success('', 'Успех!')
normal_modal_close('formModalNewEmployeeCv')
<% else %>
toastr.error('<%= j @text %>', 'Неудача!')
<% end %>