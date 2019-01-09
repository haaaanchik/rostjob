<% if @status == 'success' %>
<% partial_form = render partial: 'users/sessions/new' %>
<% over_partial = render_escape 'layouts/modal_right', {modal_name: 'Login',
local_render: partial_form } %>
normal_modal_close 'formModalSignIn'
normal_modal_close 'formModalResetLogin'
normal_modal_close 'formModalLogin'
setTimeout (->
  normal_modal_open 'formModalLogin', "<%= over_partial %>"
), 300
toastr.error('Необходимо подтвердить электронную почту!', 'Неудача!', {timeOut: 5000})
<% else %>
toastr.error('<%= @status %>', 'Не сохранено!', {timeOut: 5000})
<% end %>