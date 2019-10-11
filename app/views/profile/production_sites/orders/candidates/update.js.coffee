<% partial_form = render partial: 'profile/orders/candidates/show' %>
<% candidate_row = render partial: 'profile/candidates/candidate', locals: { candidate: @candidate } %>
<% over_partial = render_escape 'layouts/modal_options',
 {modal_name: 'ShowEmployeeCv', local_render: partial_form } %>
normal_modal_close 'formModalHdCorrection'
$('#candidate_<%= @candidate.id %>').replaceWith('<%= j candidate_row %>')
normal_modal_open 'formModalShowEmployeeCv', "<%= over_partial %>"
