redirect_func = ->
  location.replace("<%= profile_proposal_employee_path(@proposal_employee) %>")

<% if @status %>
setTimeout(redirect_func, 3000)
toastr.success('Перенос анкеты успешно завершён')
<% else %>
toastr.error('Ошибка!')
<% end %>

