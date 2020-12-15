<% over_partial = render_escape 'modal_proposal_employee', { candidate: @proposal_employee.decorate, redirect_to: @redirect } %>
normal_modal_open('empl-form', "<%= over_partial %>")
