<% if @status == 'success' %>
<% rdr = render partial: 'profile/employee_cvs/employee_cv',
 object: @employee_cv %>
$('#candidates_list').prepend('<%= j rdr %>')
toastr.success('', 'Успех!')
$('#employee_cvs_list')[0].click()
normal_modal_close('formModalNewEmployeeCv')
<% else %>
toastr.error('<%= j @text %>', 'Неудача!')
<% end %>
