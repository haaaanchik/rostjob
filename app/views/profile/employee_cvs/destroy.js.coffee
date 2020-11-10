<% if @result.success? %>
  $('.moveable[data-emp-cv-id="<%= @result.employee_cv.id %>"').remove()
  toastr.success('Анкета успешно удалена!')
<% else %>
  toastr.error('Не удалось удалить анкету!')
<% end %>
