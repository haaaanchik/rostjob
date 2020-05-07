class CopyOrder
  @init: ->
    @bind()

  @bind: ->
    $('#order_page').on 'click', 'p.copy', @copyProcess

  @copyProcess: ->
    copy_body_container = $(this).data('clipboard-target')
    copy_text = ''
    $(copy_body_container + ' p, ' + copy_body_container + ' li').each (index, elem) ->
      row = $(this).text().trim()
      return if row == ''
      copy_text += row
      if index == 2
        copy_text += ' \n\n '
      else
        copy_text += ' \n '

    copy_to_clipboard(copy_text)

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
    toastr.success('Заявка скопирована!') if successful


$(document).on 'turbolinks:load', ->
  CopyOrder.init()