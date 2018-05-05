$ ->
  $("table").on('click', '.clickable-row', (event) ->
    window.location = $(event.currentTarget).data('href')
  )
