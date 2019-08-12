@show_validation_errors = (errors) ->
  keys = Object.keys(errors)
  keys.forEach((key) ->
    id = key.replace(/\//g, '_')
    console.log key + ' ' + errors[key]
    element = $("[id=#{id}]")
    if /_base/.test(key)
      toastr.error(errors[key])
    else
      invalid_feedback = element.next('.invalid-feedback').html(errors[key])
      element.addClass('is-invalid')
  )

