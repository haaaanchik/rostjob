@show_validation_errors = (errors) ->
  keys = Object.keys(errors)
  keys.forEach((key) ->
    id = key.replace(/\//g, '_')
    console.log key + ' ' + errors[key]
    element = $("[id=#{id}]")
    if /_base/.test(key)
      toastr.error(errors[key])
    else if $("select##{key}").length != 0
      console.log $("select##{key}")
      invalid_feedback = element.parent().find('.invalid-feedback').html(errors[key])
      element.addClass('is-invalid')
      if element.hasClass('select2-hidden-accessible')
         element.siblings('.select2').find('.select2-selection').addClass('is-invalid')  # Добавляем класс is-invalid к родительскому контейнеру селекта

    else
      console.log '222222222'
      invalid_feedback = element.next('.invalid-feedback').html(errors[key])
      element.addClass('is-invalid')
  )

