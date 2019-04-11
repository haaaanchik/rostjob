# $('#employee_cvs_ready')[0].click()
<% if @status == 'success' %>
normal_modal_close('formModalNewEmployeeCv')
<% partial_form = render partial: 'profile/proposal_employees/form' %>
<% over_partial = render_escape 'layouts/modal_options', {modal_name: 'ArrivalDate', local_render: partial_form } %>
normal_modal_open 'formModalArrivalDate', "<%= over_partial %>"
<% end %>
