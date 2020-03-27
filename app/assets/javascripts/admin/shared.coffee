@search_term = (event) ->
  label = event.label
  url = window.location.href.split('?')[0]
  new_url = "#{url}?term=#{label}"
  window.location.href = new_url

@search_ransack_title = (event) ->
  label = event.value
  url = window.location.href.split('?')[0]
  new_url = "#{url}?q%5Dtitle_fields_cont%5D=#{label}"
  window.location.href = new_url