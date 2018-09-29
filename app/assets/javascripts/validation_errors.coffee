@show_validation_errors = (errors) ->
  keys = Object.keys(errors)
  keys.forEach((key) ->
    console.log key + ' ' + errors[key]
    element = $("[id=#{key}]")
    if /_base/.test(key)
      toastr.error(errors[key])
    else
      invalid_feedback = element.next('.invalid-feedback').html(errors[key])
      element.addClass('is-invalid')
  )

