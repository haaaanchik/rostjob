class RostJob.AdminProposalEmployeesIndex
  @init: ->
    RostJob.EmployeeCvsBase.init()
    @bind()

  @bind: ->
    $('.clickable-tickets').on 'click', clickableTickets
    $('.clickable-tickets').on 'mouseenter', clickableTicketsCursor
    $("[data-page='AdminProposalEmployeesIndex']").on 'click', '#hire_submit.btn', submitForm
    $("[data-page='AdminProposalEmployeesIndex']").on 'click', "[data-toggle='popover']", hidePopover

  submitForm = () ->
    if $(this).data('order-completed')
      return if !confirm('Заявка была закрыта, вы действительно хотите нанять?')

    $("#hire_form", '[data-remote=true]').submit()

  hidePopover = () ->
    $('[data-toggle=popover]').not(this).popover('hide')

  clickableTickets = (event) ->
    window.location = $(event.currentTarget).closest('td').data('href')

  clickableTicketsCursor = () ->
    $(this).css('cursor', 'pointer')

