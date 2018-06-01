$ ->
  $("table").on('click', '.clickable-row', (event) ->
    window.location = $(event.currentTarget).data('href')
  )

  $('.new-proposal-form').on('ajax:success', (event) ->
    errors = event.detail[0]
    reducer = (acc, key) ->
      if key.split('.')[1] == 'file'
        new_key = 'file_path'
      else
        new_key = "proposal_messages_attributes_0_#{key.split('.')[1]}"
      new_value = errors[key][0]
      acc[new_key] = new_value
      acc

    error_messages = Object.keys(errors).reduce(reducer, {})
    $("[id*='proposal_messages_attributes_0_']").removeClass('invalid')
    for k, v of error_messages
      $("label[for=#{k}]").attr('data-error', v)
      $("##{k}").addClass('invalid')
  )

  $('.invalid').on('focusin', (event) ->
    $(event.currentTarget).removeClass('invalid')
  )
