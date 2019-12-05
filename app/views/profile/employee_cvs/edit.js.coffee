<% partial_form = render partial: 'profile/employee_cvs/form_fields',
locals: { employee_cv: @employee_cv, url: profile_employee_cvs_path, col_md: 'col-md-10', show_title: false} %>
<% over_partial = render_escape 'layouts/modal_options',
 {modal_title: 'Анкета', modal_name: 'NewEmployeeCv', local_render: partial_form } %>
normal_modal_open 'formModalNewEmployeeCv', "<%= over_partial %>"
