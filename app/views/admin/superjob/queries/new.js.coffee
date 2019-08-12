<% partial_form = render partial: 'form', locals: { query: @query } %>
<% over_partial = render_escape 'layouts/modal_options',
 { modal_name: 'NewSuperJobQuery', local_render: partial_form } %>
normal_modal_open 'formModalNewSuperJobQuery', "<%= over_partial %>"
