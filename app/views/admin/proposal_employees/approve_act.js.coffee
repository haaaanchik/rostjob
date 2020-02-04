<% if @result.success? %>
  $('tr[data-pr-employee-id=<%= @result.candidate.id %>]').fadeOut(500)
  toastr.success('Оплата успешно подтверждена!')
<% else %>
  toastr.error('Не удалось подтвердить оплату, пожалуйста обратитсь к администратору!')
<% end %>