<% partial_show = render 'show', production_site: @production_site, order: @order, col_class: 'col-md-12' %>
<% over_partial = render_escape 'layouts/modal_options', { modal_name: 'NewOrderTemplate', local_render: partial_show } %>
normal_modal_open('formModalNewOrderTemplate', "<%= over_partial %>")
