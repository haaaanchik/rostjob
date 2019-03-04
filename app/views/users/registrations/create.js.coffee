<% if @status == 'success' %>
normal_modal_close 'formModalSignIn'
normal_modal_close 'formModalResetLogin'
normal_modal_close 'formModalLogin'
toastr.info('На указанный вами адрес электронной почты направлена ссылка для активации учетной записи', 'Внимание!', {timeOut: 5000})
<% else %>
toastr.error('<%= @status %>', 'Не сохранено!', {timeOut: 5000})
<% end %>
