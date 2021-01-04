class RostJob.EmployeeCvsBase

  @init: ->
    @bind()

  @bind: ->
    $("[data-page='AdminProposalEmployeesIndex']").on 'click', ".popover input[type='submit']", @HideAfterSubmitOrClickOther
    $("[data-page='AdminProposalEmployeesIndex']").on 'click', 'button[data-toggle=popover]', @hideOtherPopover
    $('.content-container').on 'click', @hideAll

  @hideOtherPopover: (e) ->
    e.stopPropagation()
    $('button[data-toggle=popover]').not(this).popover('hide')

  @HideAfterSubmitOrClickOther: ->
    $('button[data-toggle=popover]').not(this).popover('hide')

  @hideAll: (e) ->
    if typeof $(e.target).data('original-title') == 'undefined' && !$(e.target).parents().is('.popover.in')
      $('button[data-toggle=popover]').popover('hide')
