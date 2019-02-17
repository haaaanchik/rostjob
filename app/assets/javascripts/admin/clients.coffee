$(document).on('change', '[name=clients_type]', (event) ->
  $(this).parents('form[id=user_search]').submit()
)
