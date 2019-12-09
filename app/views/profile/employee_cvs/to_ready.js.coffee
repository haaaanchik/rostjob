<% if @status == 'success' %>
toastr.success('asd', 'Успех!')
$('#profile_cvs_<%= @employee_cv.id %>').remove()
$('#employee_cvs_list')[0].click()
<% else %>
toastr.error('<%= j @text %>', 'Неудача!')
<% end %>
