class RostJob.AdminTicketsShow
  @init: ->
    @bind()

  @bind: ->
    $("[data-page='AdminTicketsShow']").on 'click', '#hire_submit.btn', @subnitForm
    $("[data-page='AdminTicketsShow']").on 'click', "[data-toggle='popover']", @hidePopover


  @subnitForm: ->
    if $(this).data('order-completed')
      if !confirm('Заявка была закрыта, вы действительно хотите нанять?')
        $('[data-toggle=popover]').popover('hide')
        return

    $("#hire_form").submit()

  @hidePopover: ->
    $('[data-toggle=popover]').not(this).popover('hide')

