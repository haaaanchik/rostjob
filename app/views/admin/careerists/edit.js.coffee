<% partial_form = render partial: 'form', locals: { careerist: @careerist } %>
<% over_partial = render_escape 'layouts/modal_options',
 { modal_name: 'EditSuperJobQuery', local_render: partial_form } %>
normal_modal_open 'formModalEditSuperJobQuery', "<%= over_partial %>"
