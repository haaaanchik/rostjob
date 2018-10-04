$(document).on('click', '#price_search', (event) ->
  term = $('#price_position_search').val()
  url = window.location.href.split('?')[0]
  new_url = "#{url}?term=#{term}"
  window.location.href = new_url
)
