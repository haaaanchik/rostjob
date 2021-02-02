class RostJob.WelcomeIndex
  @init: ->
    @bind()

  @bind: ->
    $('.seekers_list.custom-scroll').on 'scroll', infiniteMessageList

  infiniteMessageList = (e) ->
    $this = $(e.currentTarget)
    per = parseInt($this.data('per'))
    page = parseInt($this.data('page'))
    loading = $this.data('loading')

    if !loading && $this.scrollTop() > $this[0].scrollHeight - $this[0].offsetHeight - 1
      $this.data('loading', true)
      $this.find('.loader').removeClass('d-none')

      $.get 'loading_candidates_interview',  { page: page }, (response) ->
        preHeight = $this.height()
        $this.find('.loader').before(response)
        $this.data('page', page + 1)
        $this.data('loading', false)
        $this.find('.loader').addClass('d-none')
        $this.off('scroll') if ($(response).length < per)
