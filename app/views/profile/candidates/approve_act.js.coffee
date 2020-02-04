<% if @result.success? %>
  $('tr[data-pr-employee-id=<%= @result.candidate.id %>]').fadeOut(500)
  toastr.success('Акт успешно подтвержден!')
<% else %>
  toastr.error('Не удалось подтвердить акт, пожалуйста обратитсь к администратору!')
<% end %>