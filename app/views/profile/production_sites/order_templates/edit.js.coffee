<% partial_form = render partial: 'form', locals: { production_site: @production_site, order_template: @order_template } %>
<% over_partial = render_escape 'layouts/modal_options',
 {modal_name: 'NewOrderTemplate', local_render: partial_form } %>
normal_modal_open 'formModalNewOrderTemplate', "<%= over_partial %>"
