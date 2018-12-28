#$ ->
#  $('.new-employee_cv-form').on('ajax:success', (event) ->
#    employee_cv = event.detail[2].response
#    $('#candidates').append(employee_cv)
#    modal_hide()
#    reset_form()
#  )
#
#  $('.new-employee_cv-form').on('ajax:error', (event) ->
#    errors = event.detail[0]
#    console.log errors
#    reducer = (acc, key) ->
#      console.log acc, key
#      if key == 'file'
#        new_key = 'file_path'
#      else
#        new_key = "employee_cv_#{key}"
#      new_value = errors[key][0]
#      acc[new_key] = new_value
#      acc
#
#    error_messages = Object.keys(errors).reduce(reducer, {})
#    $("[id*='proposal_messages_attributes_0_']").removeClass('invalid')
#    for k, v of error_messages
#      $("label[for=#{k}]").attr('data-error', v)
#      $("##{k}").addClass('invalid')
#  )
#
#  $("[name*='employee_cv']").on('focusin', (event) ->
#    $(event.currentTarget).removeClass('invalid')
#  )
#
#  $("[name='employee_cv[file]']").on('change', (event) ->
#    $('.file-path').removeClass('invalid')
#  )
$ ->
  $("[data-cvs-index-show]").on('click', (event) ->
    event.preventDefault()

    $(this).tab('show')

    val = $(this).data('cvs-index-show')
    if val == 'all'
      $('[data-cvs-state]').show()
    else
      $('[data-cvs-state]').hide()
      $('[data-cvs-state="' + val + '"]').show()
  )

  $("#proposal_select_employee_cv").on('change', (event) ->
    empl = $(this).val()
    url = '/profile/employee_cvs/' + empl + '/add_proposal'
    data = {proposal_id: $(this).data('proposal_id')}
    $.ajax
      method: 'put'
      url: url
      data: data
    return
  )

  $('[id^="prp_employee_cv_state"]').on('change', (event) ->
    state = $(this).val()
    cvs_pr = $(this).attr('id').split('_').slice(-1)
    url = '/profile/employee_cvs/' + cvs_pr + '/change_status'
    data = {state: state}
    $.ajax
      method: 'put'
      url: url
      data: data
    return
  )

#modal_hide = ->
#  $('#newCandidateModal').modal('hide')
#
#reset_form = ->
#  $("[name='employee_cv[name]']").val('')
#  $("[name='employee_cv[birthdate]']").val('')
#  $("[name='employee_cv[file]']").val('')
#  $('.file-path').val('')
