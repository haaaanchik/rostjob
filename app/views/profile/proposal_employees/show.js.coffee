<% partial_form = render partial: 'profile/proposal_employees/show' %>
<% over_partial = render_escape 'layouts/modal_options',
 {modal_name: 'ShowEmployeeCv', local_render: partial_form } %>
normal_modal_open 'formModalShowEmployeeCv', "<%= over_partial %>"
