<% if @status == 'success' %>
toastr.success('', 'Успех!')
$('#employee_cvs_ready')[0].click()
normal_modal_close('formModalNewEmployeeCv')
<% else %>
toastr.error('<%= j @text %>', 'Неудача!')
<% end %>
