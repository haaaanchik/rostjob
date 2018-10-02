@search_term = (event) ->
  label = event.label
  url = window.location.href.split('?')[0]
  new_url = "#{url}?term=#{label}"
  window.location.href = new_url
