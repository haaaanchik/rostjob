$(document).on('submit', '.export-form', (event) ->
  func = ->
    $('input[name=commit]').prop('disabled', false)
  setTimeout(func, 2000)
)
