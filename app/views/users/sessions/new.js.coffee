<% partial_form = render partial: 'users/sessions/new' %>
<% over_partial = render_escape 'layouts/modal_right', {modal_name: 'Login',
local_render: partial_form } %>
normal_modal_open 'formModalLogin', "<%= over_partial %>"
