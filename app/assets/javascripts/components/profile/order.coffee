class RostJob.ProfileProductionSitesOrdersShow
  @init: ->
    @bind()

  @bind: ->
    $(document).on 'click', '.js-plus', @plusProposal
    $(document).on 'click', '.js-minus', @minusProposal

  @plusProposal: ->
    num = Number($('#personalNumber').val()) + 1
    $('#personalNumber').val(num)

  @minusProposal: ->
    if Number($('#personalNumber').val()) > 1
      num = Number($('#personalNumber').val()) - 1
      $('#personalNumber').val(num)