$(document).on('click', '[id^=candidate_filter_]', ->
  form = $('#proposal_employee_search')[0]
  form.submit()
)
