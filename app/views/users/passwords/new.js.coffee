<% partial_form = render partial: 'users/passwords/new' %>
<% over_partial = render_escape 'layouts/modal_right', {modal_name: 'ResetLogin',
local_render: partial_form } %>
normal_modal_close 'formModalSignIn'
normal_modal_close 'formModalLogin'
normal_modal_open 'formModalResetLogin', "<%= over_partial %>"
