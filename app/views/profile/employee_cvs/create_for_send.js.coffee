# $('#employee_cvs_ready')[0].click()
<% if @status == 'success' %>
normal_modal_close('formModalNewEmployeeCv')
<% partial_form = render partial: 'profile/proposal_employees/form', locals: { order_id: @order.id, employee_cv_id: @employee_cv.id }  %>
<% over_partial = render_escape 'layouts/modal_options', { modal_name: 'InterviewDate', modal_size: 'md', local_render: partial_form } %>
normal_modal_open 'formModalInterviewDate', "<%= over_partial %>"
<% end %>
