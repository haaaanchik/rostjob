<% partial_form = render partial: 'profile/orders/candidates/hd_correction' %>
<% over_partial = render_escape 'layouts/modal_options',
 {modal_name: 'HdCorrection', local_render: partial_form } %>
normal_modal_close 'formModalShowEmployeeCv'
normal_modal_open 'formModalHdCorrection', "<%= over_partial %>"
