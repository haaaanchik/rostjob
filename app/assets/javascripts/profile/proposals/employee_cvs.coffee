$ ->
  $('.new-employee_cv-form').on('ajax:success', (event) ->
    employee_cv = event.detail[2].response
    $('#candidates').append(employee_cv)
    modal_hide()
    reset_form()
  )

  $('.new-employee_cv-form').on('ajax:error', (event) ->
    errors = event.detail[0]
    console.log errors
    reducer = (acc, key) ->
      console.log acc, key
      if key == 'file'
        new_key = 'file_path'
      else
        new_key = "employee_cv_#{key}"
      new_value = errors[key][0]
      acc[new_key] = new_value
      acc

    error_messages = Object.keys(errors).reduce(reducer, {})
    $("[id*='proposal_messages_attributes_0_']").removeClass('invalid')
    for k, v of error_messages
      $("label[for=#{k}]").attr('data-error', v)
      $("##{k}").addClass('invalid')
  )

  $("[name*='employee_cv']").on('focusin', (event) ->
    $(event.currentTarget).removeClass('invalid')
  )

  $("[name='employee_cv[file]']").on('change', (event) ->
    $('.file-path').removeClass('invalid')
  )

modal_hide = ->
  $('#newCandidateModal').modal('hide')

reset_form = ->
  $("[name='employee_cv[name]']").val('')
  $("[name='employee_cv[birthdate]']").val('')
  $("[name='employee_cv[file]']").val('')
  $('.file-path').val('')
