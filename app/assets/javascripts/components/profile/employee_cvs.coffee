class RostJob.ProfileEmployeeCvsIndex
  $orderId = null
  $employeeCvId = null
  $prEmployeeId = null
  $popoverPosition = null
  $currentComment = null
  $choosen = true
  $counter = 0

  @init: ->
    @draggableInit()
    @clickProposalEmployee()
    @clickNewCandidate()
    @bind()

  @bind: ->
    $('#proposal_select_employee_cv').on 'change', @proposalSelectEmployeeCv
    $('[id^="prp_employee_cv_state"]').on 'change', @prpEmployeeCvState
    $(document).on 'show.bs.modal', '#formModalNewEmployeeCv', @showBsModal
    $('.reminder_date_datepicker').on 'changeDate', @reminderChangeDate
    $('.comment-emp-cv').on 'click', @activateСomment
    $('body').on 'click', '.btn-interview', @sentEmployeeCv
    $('body').on 'click', '.btn-interview-cancel', @cancelInterview
    $('.js-call-popup').on 'click', @getCoord
    $('.js-close-popup').on 'click', @closeReminder
    $('.add-reminder').on 'click', @addReminder
    $('.js-arrow ').on 'click', @hiddenFavoriteBlock
    $('.chosen .card-scroll-window .card').on 'dragenter', @openCardBody
    $('.chosen .card-scroll-window .card').on 'dragleave', @closeCardBody


  @proposalSelectEmployeeCv: (event) ->
    empl = $(this).val()
    url = '/profile/employee_cvs/' + empl + '/add_proposal'
    data = {proposal_id: $(this).data('proposal_id')}
    $.ajax
      method: 'put'
      url: url
      data: data
    return

  @clickProposalEmployee: ->
    if $('#employee_cv_link').length
      $('#employee_cv_link')[0].click()
    if $('#proposal_employee_link').length
      $('#proposal_employee_link')[0].click()

  @clickNewCandidate: ->
    param = location.search.match(/modal=new_empl/g)
    paramModal = if param == null then null else param[0]
    return if paramModal != 'modal=new_empl'

    $.ajax
      url: '/profile/employee_cvs/new'
      method: 'GET'
      data: location.search
      dataType: 'script'
      cache: false
      processData: false
      contentType: false


  @prpEmployeeCvState: (event) ->
    state = $(this).val()
    cvs_pr = $(this).attr('id').split('_').slice(-1)
    url = '/profile/employee_cvs/' + cvs_pr + '/change_status'
    data = {state: state}
    $.ajax
      method: 'put'
      url: url
      data: data
    return

  @showBsModal: ->
    $('input[type=tel]').inputmask("+7(999)-999-99-99")

  reminderDateDatepicker = () ->
    date = $('#reminder_popup #reminder_date').val()
    $('.reminder_date_datepicker').datepicker
      language: 'ru'
      todayHighlight: true

    $('.reminder_date_datepicker').datepicker('setDate', date)

  setDefaultComment = () ->
    $currentComment.val('Напомнить мне!') unless $currentComment.val().length

  @draggableInit: ->
    arrEl = $('.js-custom-column-body, .js-card-scroll-window')
    i = 0
    while i < arrEl.length
      elem = arrEl[i]
      try
        Sortable.create elem,
          group: name: 'sorting'
          onChoose: (e) ->
            $choosen = true
          onRemove: (evt) ->
            removeAndAddStyle(evt)
          onEnd: (evt) ->
            $counter = 0
            currentState = $(evt.to).data('state')
            prevState = $(evt.from).data('state')
            return if currentState == prevState
            changeState(evt, currentState, prevState)
            return
          animation: 100
      catch e
        console.log 'не вышло создание движущихся элементов'
      i++

  @reminderChangeDate: ->
    date = $(this).datepicker('getFormattedDate')
    $('#reminder_popup #reminder_date').val(date)

  @activateСomment: (event) ->
    event.preventDefault()
    parent = $(this).parents('.card-header')
    parent.next().find('textarea.card_textarea').click()

  @sentEmployeeCv: ->
    $popoverPosition.popover('hide', animation: true)
    date = $(this).parents('.popover-body').find('#interview_date').val()
    $.ajax
      method: 'post'
      url: '/profile/proposal_employees'
      dataType: 'json'
      data:
        proposal_employee:
          order_id: $orderId
          employee_cv_id: $employeeCvId
          interview_date: date
        draggable: true
      success: (data) ->
        $popoverPosition.parent().data('proposal-emp-id', data.pr_employee_id)
        toastrMessages(true)
      error: (msg) ->
        toastrMessages(false)

  @cancelInterview: ->
    $popoverPosition.popover('hide', animation: true)
    window.location.reload()

  @getCoord: (evt) ->
    cur_input = evt.target
    coords = cur_input.getBoundingClientRect()
    answer_x = coords.left
    answer_y = coords.top
    $('.triangle').css('top', 5+'px'); # сдвиг на 5 пикселей для красоты
    if document.documentElement.clientHeight - coords.y < 434 # 434 полная высота напоминания
      answer_y = coords.top - 400 # сдвиг на 400 пикселей вверх
      $('.triangle').css('top', 405+'px');
    if answer_y < 60 # 60 - это высота header на странице, отнимая выкидываю ее из учета
      click_y = coords.y - 60
      answer_y = 60
      $('.triangle').css('top', click_y+'px');
    popup = document.querySelector('.popup')
    popup.style.left = answer_x - (coords.width + 58 )  + 'px' # на 46 пикселей напоминание больше инпута + 12px стрелочка
    popup.style.top = answer_y + 'px'
    if $(window).width() < 900
      popup.style.left = answer_x + 'px'
      popup.style.top = answer_y + 40 + 'px'
      answer_bottom = coords.bottom
      content_wrapper = document.querySelector('.content-wrapper').getBoundingClientRect()
      if content_wrapper.height - (coords.bottom) < 242
        popup.style.left = answer_x + 'px'
        popup.style.top = answer_y - 245 + 'px'
    clearAndSetDateInput($(this))
    reminderDateDatepicker()
    $currentComment = $(this)
    setDefaultComment()
    setResetReminderHref($(this))
    popup.style.display = 'block'
    return

  setResetReminderHref = (position) ->
    id = position.parents('.moveable').data('emp-cv-id')
    $('.close-reminder').attr('href', '/profile/employee_cvs/' + id + '/reset_reminder')

  @closeReminder: ->
    $('.popup').slideToggle()
    column = $currentComment.parents('.card-body.js-custom-column-body')
    $currentComment.val('') if column.data('state') != 'reminder'
    $currentComment = null
    return

  @addReminder: ->
    parent = $(this).closest('.popup')
    date = parent.find('#reminder_date').val()
    time = parent.find('#reminder_time').val()
    comment = $currentComment.val()
    empCvId = $currentComment.closest('.moveable').data('emp-cv-id')
    if date == '' || time == '' || comment == ''
      toastr.error('Пожалуйста добавьте дату, время и комментарий')
      return

    $.ajax
      method: 'put'
      url: '/profile/employee_cvs/' + empCvId
      dataType: 'json'
      data:
        employee_cv:
          reminder: date + ' ' + time + ' UTC'
          comment: comment
        draggable: true
      success: (data) ->
        $('.popup').fadeOut 'fast'
        $currentComment.parent().find('span').remove()
        $currentComment.parent().append(data.reminder_date)
        $currentComment = null
        toastr.success('Напоминание успешно доабвлено')
        Turbolinks.visit(window.location.href)
      error: (msg) ->
        toastrMessages(false)
    return

  @hiddenFavoriteBlock: ->
    $(this).parent('.card-header').next('.js-slide-elem').slideToggle()

  @openCardBody = (e) ->
    $counter++
    if !e.target.classList.contains('card-header')
      return false
    else
      target = $(e.target)
    if $choosen == true && e.target.classList.contains('card-header')
      target.next().slideDown()
      e.preventDefault()
    return

  @closeCardBody = (e) ->
    $counter--
    if $counter == 0
      if !e.target.classList.contains('card-header')
        return false
      else
        target = $(e.target)
      target.next().slideUp()
      return


  clearAndSetDateInput = ($this) ->
    newDate = new Date()
    hours = if newDate.getHours() < 10 then "0#{newDate.getHours()}" else newDate.getHours()
    minutes = if newDate.getMinutes() < 10 then "0#{newDate.getMinutes()}" else newDate.getMinutes()
    date = if $this.data('date') == undefined then newDate else $this.data('date')
    time = if $this.data('time') == undefined then "#{hours}:#{minutes}" else $this.data('time')
    $('#reminder_popup').find('#reminder_date').val(date)
    $('#reminder_popup').find('#reminder_time').val(time)

  removeAndAddStyle= (evt) ->
    itemEl = $(evt.item)
    currentState = $(evt.to).data('state')
    prevState = $(evt.from).data('state')
    if currentState == 'favorite'
      parent = itemEl.parent()
      parent.attr('style', null) if parent.find('.moveable').length > 1
      return
    if prevState == 'favorite'
      currentEl =  $(evt.from)

  changeState = (evt, currentState, prevState) ->
    itemEl = evt.item
    $(itemEl).find('.card-tools').fadeIn 500
    empCvId = $(itemEl).data('emp-cv-id')
    if currentState == 'favorite'
      $orderId = $(evt.to).parents('.moveable').data('order-id')
      $employeeCvId = empCvId
      $popoverPosition = $(itemEl).find('.interview-date-show')
      $popoverPosition.popover('show', animation: true)
      $(itemEl).find('.card-tools').fadeOut 500
      $(itemEl).find('i.fas.fa-bookmark.right-top').css('color', '#ffd800')
      return

    if currentState == 'reminder'
      $currentComment = $(itemEl).find('#comment')
      $currentComment.click()
      toastr.info('Пожалуйста установите дату, время и комментарий')
      return if prevState != 'favorite'

    if prevState == 'favorite'
      prEmpId = $(itemEl).data('proposal-emp-id')
      url = '/profile/proposal_employees/' + prEmpId + '/revoke'
      $(itemEl).find('i.fas.fa-bookmark.right-top').css('color', '#9046ff')
      $(itemEl).find('.card-tools').removeClass('d-none')
      draggable = true

    if currentState == 'ready' && prevState != 'favorite'
      url = '/profile/employee_cvs/' + empCvId + '/to_ready'
      draggable =  if prevState == 'reminder' then true else false

    sendAjaxRequest(url, draggable)

  sendAjaxRequest= (url, draggable) ->
    $.ajax
      method: 'put'
      url: url
      dataType: 'json'
      data:
        draggable: draggable
      success: (data) ->
        toastrMessages(true)
      error: (msg) ->
        toastrMessages(false)

  toastrMessages = (success) ->
    if success
      toastr.success('Анкета успешно перенеса')
    else
      toastr.error('Не удалось перенести анкету, пожалуйста обновите страницу и обратитесь к администратору')