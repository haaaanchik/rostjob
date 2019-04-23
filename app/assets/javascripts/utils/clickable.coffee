$ ->
  $(document).on('click', '.clickable-row', (event) ->
    window.location = $(event.currentTarget).data('href')
  )
  $(document).on('mouseenter', '.clickable-row', (event) ->
    $(this).css('cursor', 'pointer')
  )

  $("ul").on('mouseenter', '.clickable', (event) ->
    $(this).css('cursor', 'pointer')
  )
