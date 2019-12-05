class EmployeeCvs
  $orderId = null
  $employeeCvId = null
  $prEmployeeId = null
  $popoverPosition = null
  $currentComment = null

  @init: ->
    @draggableInit()
    @bind()

  @bind: ->
    $('#proposal_select_employee_cv').on 'change', @proposalSelectEmployeeCv
    $('[id^="prp_employee_cv_state"]').on 'change', @prpEmployeeCvState
    $(document).on 'click', 'label[for=proposal_employee_employee_cv_attributes_contractor_terms_of_service]', @termsOfService
    $(document).on 'show.bs.modal', '#formModalNewEmployeeCv', @showBsModal
    $('.reminder_date_datepicker').on 'changeDate', @reminderChangeDate
#    $('.remote-block').on 'click', @remoteBlock
    $('.comment-emp-cv').on 'click', @activateСomment
    $(document).on 'click', '.btn-interview', @sentEmployeeCv
    $(document).on 'click', '.btn-interview-cancel', @cancelInterview
    $('.js-call-popup').on 'click', @getCoord
    $('.close-reminder').on 'click', @closeReminder
    $('.add-reminder').on 'click', @addReminder

  @proposalSelectEmployeeCv: (event) ->
    empl = $(this).val()
    url = '/profile/employee_cvs/' + empl + '/add_proposal'
    data = {proposal_id: $(this).data('proposal_id')}
    $.ajax
      method: 'put'
      url: url
      data: data
    return

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

  @termsOfService: (event) ->
    console.log 'aaa'
    element = $('#proposal_employee_employee_cv_attributes_contractor_terms_of_service')
    checked = element.prop('checked')
    if checked == false
      $('.proposal-employee-cv-submit-button').removeClass('disabled')
    else
      $('.proposal-employee-cv-submit-button').addClass('disabled')

  @showBsModal: ->
    $('input[type=tel]').inputmask("+7(999)-999-99-99")

  reminderDateDatepicker = () ->
    date = $('#reminder_date').val()
    $('.reminder_date_datepicker').datepicker
      language: 'ru'
      todayHighlight: true

    $('.reminder_date_datepicker').datepicker('setDate', date)

  @draggableInit: ->
    arrEl = $('.js-custom-column-body, .js-card-scroll-window')
    i = 0
    while i < arrEl.length
      elem = arrEl[i]
      try
        Sortable.create elem,
          group: name: 'sorting'
          onRemove: (evt) ->
            removeAndAddStyle(evt)
          onEnd: (evt) ->
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
    $('#reminder_date').val(date)

#  @remoteBlock: ->
#    $(this).children().last().toggleClass('fa-chevron-up fa-chevron-down')
#    $('.remote-empl_cvs').fadeToggle(500)

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
    popup = document.querySelector('.popup')
    popup.style.left = answer_x - 270 + 'px'
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
    popup.style.display = 'block'
    return

  @closeReminder: ->
    $('.popup').fadeOut 'fast'
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
        return
      error: (msg) ->
        toastrMessages(false)
    return

  clearAndSetDateInput = ($this) ->
    date = if $this.data('date') == undefined then $('#reminder_date').val() else $this.data('date')
    time = if $this.data('time') == undefined then $('#reminder_time').val() else $this.data('time')
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
      currentEl.attr('style', 'height: auto') if currentEl.find('.moveable').length < 1

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
      return

    if currentState == 'reminder'
      $currentComment = $(itemEl).find('#comment')
      $currentComment.click()
      toastr.info('Пожалуйста установите дату, время и комментарий')
      return if prevState != 'favorite'

    if prevState == 'favorite'
      prEmpId = $(itemEl).data('proposal-emp-id')
      url = '/profile/proposal_employees/' + prEmpId + '/revoke'

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

$(document).on 'turbolinks:load', ->
  EmployeeCvs.init()