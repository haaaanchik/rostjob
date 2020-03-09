class Welcome
  @init: ->
    @fullcalendarInit() if $('#calendar').length

  @fullcalendarInit: ->
    calendarEl = $('#calendar')[0]

    calendar = new FullCalendar.Calendar(calendarEl, {
      plugins: ['dayGrid']
      eventLimit: true
      locale: 'ru'
      firstDay: 1
      header:
        left: ''
        center: 'prev title next'
        right: ''
      events: '/calendar_events.json'
      eventRender: (element) ->
        element.el.dataset.toggle = 'tooltip'
        element.el.dataset.placement = 'top'
        element.el.title = element.event.extendedProps.tooltip
        return
    })

    calendar.render()

$(document).on 'turbolinks:load', ->
  Welcome.init()

$(document).on('ajax:success', '.left-menu', (event) ->
  detail = event.detail
  xhr = detail[2]
  $('#right_window').html(xhr.response)
)
