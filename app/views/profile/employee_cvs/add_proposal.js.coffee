<% if @status == 'success' %>
<% rdr = render partial: 'profile/employee_cvs/employee_cv', object: @employee_cv %>
$('#profile_cvs_<%= @employee_cv.id %>').replaceWith '<%= j rdr %>'
toastr.success('', 'Успех!')
normal_modal_close('formModalMyOrders')
<% else %>
toastr.error('<%= j @text %>', 'Неудача!')
<% end %>
