class RostJob.OrdersBase
  @init: ->
    @bindFilerts()

  @bindFilerts: ->
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
