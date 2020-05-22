<% partial_form = render partial: 'form', locals: {production_site: @production_site} %>
<% over_partial = render_escape '/partials/modal',
 { modal_title: 'Укажите данные о производственной площадке', local_render: partial_form, modal_id: 'modal-production-site' } %>
normal_modal_open 'modal-production-site', "<%= over_partial %>"
