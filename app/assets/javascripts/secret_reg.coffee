#= require external/jquery-3.3.1.min
#= require rails-ujs

valid = ->
  email = $("input[name='user[email]']")
  submit = $("button[name='customer']")
  regEx =/^[a-z0-9_-]+@[a-z0-9-]+\.[a-z]{2,6}$/i
  email.on 'change keyup input click', ->
    if email.val().search(regEx) == 0
      submit.prop 'disabled', false
    else
      submit.prop 'disabled', true
    return
  return

submit = ->
  email = $("input[name='user[email]']")
  submit = $("button[name='customer']")
  regEx =/^[a-z0-9_-]+@[a-z0-9-]+\.[a-z]{2,6}$/i
  submit.click (event) ->
    cosnole.log('-1111111')
    if email.val().search(regEx) == 0
      alert 'Ваш email был отправлен, ожидайте ответа'
      submit.prop 'disabled', true
    else
      event.preventDefault()
      email.parent().addClass 'alert'
      submit.prop 'disabled', true
    return
  return

$(document).ready ->
  valid()
  submit()
  return