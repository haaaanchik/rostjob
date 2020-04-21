<% over_partial = render_escape 'profile/employee_cvs/form', { url: profile_employee_cvs_path, mth: :post} %>
normal_modal_open('empl-form', "<%= over_partial %>")
