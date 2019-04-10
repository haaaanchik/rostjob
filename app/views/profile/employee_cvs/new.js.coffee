<% partial_form = render partial: 'profile/employee_cvs/form',
locals: { url: profile_employee_cvs_path, mth: :post} %>
<% over_partial = render_escape 'layouts/modal_options',
 {modal_title: 'Анкета', modal_name: 'NewEmployeeCv', local_render: partial_form } %>
normal_modal_open 'formModalNewEmployeeCv', "<%= over_partial %>"
