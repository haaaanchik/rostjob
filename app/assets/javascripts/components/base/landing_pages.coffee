class RostJob.LandingPages
  @init: ->
    @bind()

  @bind: ->
    $('.js-call-modal').on 'click', @openModal
    $('#overlay, .js-close-modal').on 'click', @closeModal
    $('#overlay .form').on 'click', @clickForm
    @openModal() if window.location.search == '?modal=request_call'

  @openModal: ->
    $('#modal').addClass('open')

  @closeModal: ->
    $('#modal').removeClass('open')

  @clickForm: (e) ->
    e.stopPropagation()
