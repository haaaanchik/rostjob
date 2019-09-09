App.chat = App.cable.subscriptions.create "BotChannel",
  connected: ->

  disconnected: ->

  received: (data) ->
    console.log data
    window.location.replace(data['employee_cv_url'])
