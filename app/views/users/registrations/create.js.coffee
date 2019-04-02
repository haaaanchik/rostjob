<% if @status == 'success' %>
normal_modal_close 'formModalSignIn'
normal_modal_close 'formModalResetLogin'
normal_modal_close 'formModalLogin'
toastr.info('На указанный вами адрес электронной почты направлена ссылка для активации учетной записи. Если письмо долго не приходит, проверьте папку "СПАМ" вашей почты.', 'Внимание!', {timeOut: 5000})
setTimeout (->
  window.location.replace('/')
), 10000
<% end %>
