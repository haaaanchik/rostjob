<% partial_form = render partial: 'form', locals: {production_site: @production_site} %>
<% over_partial = render_escape 'modal',
 { modal_title: 'Укажите данные о производственной площадке', local_render: partial_form } %>
normal_modal_open 'modal-production-site', "<%= over_partial %>"
