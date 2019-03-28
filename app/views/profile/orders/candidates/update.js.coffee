<% partial_form = render partial: 'profile/orders/candidates/show' %>
<% over_partial = render_escape 'layouts/modal_options',
 {modal_name: 'ShowEmployeeCv', local_render: partial_form } %>
normal_modal_close 'formModalHdCorrection'
normal_modal_open 'formModalShowEmployeeCv', "<%= over_partial %>"
