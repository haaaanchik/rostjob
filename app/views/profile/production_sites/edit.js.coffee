<% partial_form = render partial: 'form', locals: {production_site: @production_site} %>
<% over_partial = render_escape 'layouts/modal_options',
 { modal_title: 'Укажите данные о производственной площадке', modal_name: 'NewProductionSite', local_render: partial_form } %>
normal_modal_open 'formModalNewProductionSite', "<%= over_partial %>"
