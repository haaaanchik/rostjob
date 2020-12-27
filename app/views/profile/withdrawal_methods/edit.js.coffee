<% partial_form = render partial: 'profile/withdrawal_methods/companies/form' %>
<% over_partial = render_escape 'layouts/modal_options',
 {modal_name: 'EditWithdrawalMethod', local_render: partial_form } %>
normal_modal_open 'formModalEditWithdrawalMethod', "<%= over_partial %>"
