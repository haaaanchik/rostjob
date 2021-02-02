<% if @user %>
  <% view = render partial: 'fail_send_cv', locals: { user: @user } %>
  <% over_partial = render_escape '/partials/modal',
    { modal_id: 'failed_send_cv', local_render: view } %>
  normal_modal_open('failed_send_cv', "<%= over_partial %>")
<% else %>
  toastr.success('Анкета успешно отправлена')
  $('#empl-form').modal('hide')
<% end %>
