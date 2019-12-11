class Users
  @init: ->
    @enjoyHintProccess()

  @enjoyHintProccess: ->
    enjoyhint_instance = new EnjoyHint({})
    skipButton = { text: 'Понял!' }
    locPath = location.pathname.match(/\d/)
    id = if locPath == null then locPath else locPath[0]
    return if $.cookie('profile_type') == 'contractor' or $.cookie('profile_type') == null or
      $.cookie('terms_of_service') == false or $.cookie('password_changed_at') == null or
      $.cookie('updated_by_self_at') == null or $.cookie('first_order_template_created') == true

    if location.pathname == '/profile/production_sites'
      script_steps = [{ '#main_row #new-production-site': 'Кнопка создания новых площадок', 'skipButton': skipButton }]
      enjoyHintRun(enjoyhint_instance, script_steps)
      return

    if location.pathname == '/profile/production_sites/' + id + '/orders'
      script_steps = [{ 'click #order-templates': 'Пожалуйста кликните по кнопке', 'skipButton': skipButton },
        { 'click #new-o_template': 'Кнопка создания нового шаблона', 'skipButton': skipButton } ]
      enjoyHintRun(enjoyhint_instance, script_steps)
      return

    script_steps = [{ '#main_row #production-site-list': 'Страница площадок', 'skipButton': skipButton }]
    enjoyHintRun(enjoyhint_instance, script_steps)

  enjoyHintRun = (enjoyhint_instance, script_steps) ->
    enjoyhint_script_steps = script_steps
    enjoyhint_instance.set enjoyhint_script_steps
    enjoyhint_instance.run()


$(document).on 'turbolinks:load', ->
  Users.init()

$ ->
  $('.clients').on('click', (event) ->
    element = event.target
    value = element.childNodes[0].value
    company_name = $('#user_profile_company_name')[0]
    company_block = $('#user_profile_company_name')[0].parentElement
    if value == 'employee' || value == 'recruiter'
      $(company_name).prop('disabled', true)
      $(company_block).hide()
    else
      $(company_name).prop('disabled', false)
      $(company_block).show()
  )

  $('.registration-form').on('ajax:success', (event) ->
    errors = event.detail[0]
    form = $(this)
    if errors['full_name']
      $('.full-name', form).html(errors['full_name'][0])
      $('#user_full_name', form).addClass('is-invalid')
    if errors['email']
      $('.email', form).html(errors['email'][0])
      $('#user_email', form).addClass('is-invalid')
    if errors['password']
      $('.password', form).html(errors['password'][0])
      $('#user_password', form).addClass('is-invalid')
  )

  $(document).on('focusin', '.is-invalid', (event) ->
    $(event.currentTarget).removeClass('is-invalid')
  )
