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
    $('body').on 'click', '#order_page .js-vacancy', @orderBlockToggleClass
    $('#add #add_column').on 'click', @addNewCrmColumn
    $('.crm-list').on 'click', '.card-title.js-title', @changeCrmColumnName
    $('.crm-list').on 'keypress', '.js-clicked-input', @saveCrmColumnName
    $('.crm-list').on 'click', '.remove_column_button', @removeColumn

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
        sortableCreate(elem)
      catch e
        console.log 'не вышло создание движущихся элементов'
      i++

  sortableCreate = (elem) ->
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
        currentColumn = $(evt.to).parents().data('crm-column-id')
        prevColumn = $(evt.from).parents().data('crm-column-id')
        return if (currentState != 'crm_column' && currentState == prevState) ||
          (currentState == 'crm_column' && currentColumn == prevColumn)

        changeState(evt, currentState, prevState, currentColumn)
        return
      animation: 100

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
        toastr.success('Напоминание успешно добавлено')
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

  changeState = (evt, currentState, prevState, currentColumn) ->
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

    if prevState == 'favorite'
      prEmpId = $(itemEl).data('proposal-emp-id')
      url = '/profile/proposal_employees/' + prEmpId + '/revoke'
      $(itemEl).find('i.fas.fa-bookmark.right-top').css('color', '#9046ff')
      $(itemEl).find('.card-tools').removeClass('d-none')
      return unless sendAjaxRequest(url, prevState)

    if currentState == 'crm_column' && prevState == 'crm_column'
      url = '/crm_columns/' + currentColumn + '/update_employee_cv'
      method = 'put'

    if currentState == 'default' && prevState == 'crm_column'
      url = '/crm_columns/destroy_employee_cv'
      method = 'delete'

    if currentState == 'crm_column' && ( prevState == 'default' || prevState == 'favorite' )
      url = '/crm_columns/' + currentColumn + '/add_employee_cv'
      method = 'post'

    addEmployeeCvToCrmColumn(url, empCvId, method)

  sendAjaxRequest= (url, prevState) ->
    $.ajax
      method: 'put'
      url: url
      dataType: 'json'
      data:
        draggable: true
      success: (data) ->
        return true
      error: (msg) ->
        toastrMessages(false)
        return false

  addEmployeeCvToCrmColumn = (url, empCvId, method) ->
    $.ajax
      url: url
      method: method
      dataType: 'json'
      data:
        crm_column:
          employee_cv_id: empCvId
      success: (data) ->
        toastrMessages(true)
      error: (msg) ->
        toastrMessages(false)

  toastrMessages = (success) ->
    if success
      toastr.success('Анкета успешно перенесена')
    else
      toastr.error('Не удалось перенести анкету, пожалуйста обновите страницу и обратитесь к администратору')

  @orderBlockToggleClass: ->
    $(this).next('.details').toggleClass('opened')

  @addNewCrmColumn: ->
    position = $(this)
    $.ajax
      url: '/crm_columns'
      method: 'post'
      dataType: 'json'
      data:
        crm_column:
          name: 'Новая колонка'
      success: (data) ->
        position.parents('#add').after(crmColumnHtml(data.id))
        sortableCreate($('.js-custom-column-body')[0])
      error: (msg) ->
        toastr.error('Не удалось добавить колонку.')

  crmColumnHtml = (id) ->
    '<div class="card card-primary custom-column mb-2 mb-sm-0 p-1" data-crm-column-id='+id+'>\
      <div class="card-header mb-2">\
        <h3 class="card-title js-title crm-column-name mb-0">Новая колонка</h3>\
        <input class="js-clicked-input" type="text" value="Новая колонка">\
        <i class="fas fa-times remove_column_button"></i>\
      </div>\
      <a class="btn btn-block add-card m-auto" data-remote="true" href="/profile/employee_cvs/new?crm_column_id='+id+'">\
        <i class="fas fa-plus mr-1"></i>\
        Добавить анкету
      </a>\
      <div class="card-body js-custom-column-body card-scroll-window" data-state="crm_column"></div>\
    </div>'


  @changeCrmColumnName: ->
    $title = $(this)
    $input = $title.next('input.js-clicked-input')
    $title.hide()
    $input.show()
    $input.focus()

  @saveCrmColumnName: ->
    key = event.which || event.keyCode
    if (key == 13)
      $input_field = $(this)
      columnId = $input_field.parents('.card').data('crm-column-id')
      title =  $(".card[data-crm-column-id='"+columnId+"']").find('.card-title.js-title')
      new_text = $input_field.val()
      console.log(columnId)
      $.ajax
        url: '/crm_columns/'+columnId
        method: 'put'
        dataType: 'json'
        data:
          crm_column:
            name: new_text
        success: (data) ->
          title.text(new_text)
          $input_field.hide()
          title.show()
          $input_field.removeClass('input-error')
        error: (msg) ->
          $input_field.addClass('input-error')
          toastr.error(msg.responseJSON.errors)

  @removeColumn: ->
    $position = $(this)
    columnId =  $position.parents('.card').data('crm-column-id')

    if confirm('Удалить колонку?')
      $.ajax
        url: '/crm_columns/'+columnId
        method: 'DELETE'
        dataType: 'json'
        success: ->
          $position.parents('.card').fadeOut 'slow', ->
            $(this).remove()
        error: ->
          toastr.error('Пожалуйста перенесите все карточки перед удалением колонки!')
