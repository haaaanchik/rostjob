<% partial_form = render partial: 'profile/employee_cvs/form',
locals: { url: profile_employee_cv_path(@employee_cv), mth: :put} %>
<% over_partial = render_escape 'layouts/modal_options',
 {modal_name: 'NewEmployeeCv', local_render: partial_form } %>
normal_modal_open 'formModalNewEmployeeCv', "<%= over_partial %>"
