<% if @status == 'success' %>
normal_modal_close('formModalShowEmployeeCv')
$('#employee_cvs_ready')[0].click()
<% else %>
toastr.info('Ошибка отзыва анкеты!')
<% end %>
