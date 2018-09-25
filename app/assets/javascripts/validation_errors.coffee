@show_validation_errors = (errors) ->
  keys = Object.keys(errors)
  keys.forEach((key) ->
    element = $("[id=#{key}]")
    console.log key + ' ' + errors[key]
    invalid_feedback = element.next('.invalid-feedback').html(errors[key])
    element.addClass('is-invalid')
  )

