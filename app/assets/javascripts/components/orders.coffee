class RostJob.OrdersCustomerOrders
  @init: ->
    @bind()

  @bind: ->
    $('#order_page').on 'click', 'p.copy', @copyProcess
    $('body').on 'click', '#order_page .js-vacancy', @orderBlockToggleClass

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

  @orderBlockToggleClass: ->
    $(this).next('.details').toggleClass('opened')

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


class RostJob.OrdersIndex
  @init: ->
    @bind()

  @bind: ->
    $('.js-checkAll').on 'click', checkAllItems
    $('.js-clearAll').on 'click', clearAllItems
    $('.js-select-title').on 'click', toggleHideSelects
    $('.js-moreDetails').on 'click', toggleHideDescription

  checkAllItems = (e) ->
    button = e.target
    selectButtonsBlock = button.closest('.select__buttons')
    selectOptionsBlock = selectButtonsBlock.previousElementSibling
    checkboxesArr = selectOptionsBlock.querySelectorAll('input')
    checkboxesArr.forEach((el) ->
      el.checked = true
    )

  clearAllItems = (e) ->
    button = e.target
    selectButtonsBlock = button.closest('.select__buttons')
    selectOptionsBlock = selectButtonsBlock.previousElementSibling
    checkboxesArr = selectOptionsBlock.querySelectorAll('input')
    checkboxesArr.forEach((el) ->
      el.checked = false
    )

  toggleHideSelects = (e) ->
    container = e.target.nextElementSibling
    citiesContainer = document.querySelector('.cities-container');
    profContainer = document.querySelector('.professions-container');
    if(container == profContainer && !citiesContainer.classList.contains('hide'))
      citiesContainer.classList.add('hide')
      citiesContainer.previousElementSibling.querySelector('.js-arrow').classList.remove('rotate')

    if(container == citiesContainer && !profContainer.classList.contains('hide'))
      profContainer.classList.add('hide')
      profContainer.previousElementSibling.querySelector('.js-arrow').classList.remove('rotate')

    e.target.nextElementSibling.classList.toggle('hide')
    arrow = e.target.querySelector('.js-arrow')
    arrow.classList.toggle('rotate')

  toggleHideDescription = (e) ->
    order = e.target.closest('.order')
    arrow = order.querySelector('.js-arrow')
    arrow.classList.toggle('rotate')
    moreDetails = order.querySelector('.moreDetails__text')
    if(!arrow.classList.contains('rotate'))
      moreDetails.textContent = 'Подробнее'
    else
      moreDetails.textContent = 'Свернуть'

    hideDescriptionBlock = order.querySelector('.js-hide-description')
    hideDescriptionBlock.classList.toggle('hide')
