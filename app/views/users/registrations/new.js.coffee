<% partial_form = render partial: 'users/registrations/new' %>
<% over_partial = render_escape 'layouts/modal_right', {modal_name: 'SignIn',
local_render: partial_form } %>
normal_modal_close 'formModalLogin'
normal_modal_close 'formModalResetLogin'
normal_modal_open 'formModalSignIn', "<%= over_partial %>"
