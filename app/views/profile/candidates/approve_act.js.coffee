<% if @result.success? %>
  Turbolinks.visit(window.location)
<% else %>
  toastr.error('Не удалось подтвердить акт, пожалуйста обратитсь к администратору!')
<% end %>