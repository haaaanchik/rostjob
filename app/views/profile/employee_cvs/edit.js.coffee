<% over_partial = render_escape 'profile/employee_cvs/modal_edit', { employee_cv: @employee_cv } %>
normal_modal_open('empl-form', "<%= over_partial %>")
