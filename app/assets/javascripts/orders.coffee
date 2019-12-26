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

  $(document).on('click', 'button[id^=copy-to-clipboard-]', (event) ->
    order_text = $(event.target).data('order')
    copy_to_clipboard(order_text)
  )

  copy_to_clipboard = (text_to_copy) ->
    textarea = document.createElement('textarea')
    textarea.value = text_to_copy
    textarea.setAttribute('readonly', '')
    textarea.style.position = 'absolute'
    textarea.style.left = '-9999px'
    document.body.appendChild(textarea)
    textarea.select()
    successful = document.execCommand('copy')
    textarea.remove()
    if successful
      toastr.success('Заявка скопирована!')

  $(document).on('click', '[id^=title_filter_], [id^=city_filter_]', ->
    form = $('#profesion-city-form')
    form.submit()
  )


  $(document).on('click', '.js-zayavka', ->
    $(this).slideUp();
    $(this).next().slideDown();
  )

  $(document).on('click', '.js-zayavka-close', ->
    $(this).parents('.collapse').slideUp()
    $(this).parents('.collapse').parent().find('.collapsable').slideDown()
  )