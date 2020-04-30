$(document).on('submit', '.export-form', (event) ->
  func = ->
    $('input[name=commit]').prop('disabled', false)
  setTimeout(func, 2000)
)

$(document).on "turbolinks:load", ->
  $('.datepicker').pickadate({
    formatSubmit: false,
    dateFormat: "yy-mm-dd"
  })
