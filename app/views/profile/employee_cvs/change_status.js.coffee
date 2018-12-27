<% if params[:state] == 'hired' %>
<% if @current_profile.customer? %>
<% partial_form = render partial: 'profile/orders/candidates/hire_form',
 locals: { proposal: @employee_cv.proposal } %>
<% over_partial = render_escape 'layouts/modal_options',
 {modal_name: 'HireCandidate', local_render: partial_form } %>
normal_modal_open 'formModalHireCandidate', "<%= over_partial %>"
<% else %>
toastr.warn('Внимание', 'Нанимать может только заказчик!')
<% end %>
<% else %>
toastr.info('Успех!', 'Данные обновлены!')
<% end %>