App.chat = App.cable.subscriptions.create "BotChannel",
  connected: ->

  disconnected: ->

  received: (data) ->
    console.log data
    window.location.replace(data['new_empl_cv_url'])
