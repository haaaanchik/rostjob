<% partial_form = render partial: 'users/registrations/new' %>
<% over_partial = render_escape 'layouts/modal_right', {modal_name: 'SignIn',
local_render: partial_form } %>
normal_modal_open 'formModalSignIn', "<%= over_partial %>"
