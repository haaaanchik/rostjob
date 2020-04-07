<% if @result.success? %>
  Turbolinks.visit(window.location)
<% else %>
  toastr.error('Не удалось подтвердить акты, пожалуйста обратитсь к администратору!')
<% end %>