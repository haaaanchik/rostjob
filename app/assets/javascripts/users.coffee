class Users
  @init: ->
    admin_path = location.pathname.match(/\/admin/g)
    @enjoyHintProccess() if admin_path == null

  @enjoyHintProccess: ->
    skipButton = { text: 'Понял!' }
    locPath = location.pathname.match(/\d+/g)
    id = if locPath == null then locPath else locPath.join()
    return profileInvoices(skipButton) if location.pathname == '/profile/invoices'
    return if $('#order_template_form').length or $.cookie('profile_type') == 'contractor' or $.cookie('profile_type') == null or
      $.cookie('terms_of_service') == 'false' or $.cookie('password_changed_at') == null or
      $.cookie('updated_by_self_at') == null or $.cookie('first_order_template_created') == 'true' or window.innerWidth < 401

    if location.pathname == '/profile/production_sites'
      productionSiteExist = $('#first_pr_site').length
      if productionSiteExist
        $selector = 'click #first_pr_site'
        message = 'Готово! Теперь рекрутеры смогут найти Вас! Перейдите по ссылке, чтобы опубликовать Вашу первую заявку.'
      else
        $selector = 'click .add-platform'
        message = 'Чтобы опубликовать Заявку Вам следует создать Площадку. Чтобы рекрутеры смогли найти ' +
          'Вас, заполните данные о месте работы в окне по этой кнопке.'
      script_steps = [{ "#{$selector}": message, 'skipButton': skipButton }]
      enjoyHintRun(script_steps)
      return

    if location.pathname == '/profile/production_sites/' + id + '/orders'
      messageFirst = 'Чтобы опубликовать заявку используйте кнопку.'
      script_steps = [{ 'click #active-content-tab': messageFirst, 'skipButton': skipButton }]
      enjoyHintRun(script_steps)
      return

    if $('#production-site-list').length
      message = 'Добро пожаловать на портал для поиска персонала ROSTJOB. Ваши заявки будут находиться здесь.'
      script_steps = [{ '#right_window #production-site-list': message, 'skipButton': skipButton }]
      enjoyHintRun(script_steps)

  enjoyHintRun = (script_steps) ->
    enjoyhint_instance = new EnjoyHint({})
    enjoyhint_script_steps = script_steps
    enjoyhint_instance.set enjoyhint_script_steps
    enjoyhint_instance.run()

  profileInvoices = (skipButton) ->
    if window.location.search == '?state=created'
      message = 'Ваш счет находится здесь. Кликните на кнопку, чтобы распечатать его.'
      script_steps = [{ 'click .file-pdf:first()': message, 'skipButton': skipButton }]
      enjoyHintRun(script_steps)
    else unless $('.allAccounts_open_table table tbody tr').length
      message = 'Пополните счет. Для этого впишите необходимую сумму и нажмите выставить счет.'
      script_steps = [{ 'click .replenishAccount_input': message, 'skipButton': skipButton }]
      enjoyHintRun(script_steps)

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
