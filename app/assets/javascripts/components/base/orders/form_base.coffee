class RostJob.OrderFormBase

  @init: ->
    @bind()
  
  @bind: ->
    $('#save-on_current_page').on 'click', @submitForm

  @submitForm: ->
    $('#redirecting_back').val('true')
    $('#order_template_form').submit()