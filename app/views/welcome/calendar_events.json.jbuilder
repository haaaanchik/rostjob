json.array!(@empl_cv_hired) do |event|
  json.extract! event, :id, :warranty_date
  json.id event.id
  json.url profile_employee_cvs_path(proposal_employee_id:  event.id)
  json.title event.employee_id_name
  json.tooltip "Гарантийный период для анкеты #{event.employee_id_name}"
  json.color '#00ca5f'
  json.textColor '#212529'
  json.start event.hiring_date
  json.end event.warranty_date + 1.days
end

json.array!(@empl_cv_interview) do |event|
  json.extract! event, :id, :interview_date
  json.id event.id
  json.url profile_employee_cvs_path(proposal_employee_id:  event.id)
  json.title event.employee_id_name
  json.color '#fd7e14'
  json.textColor '#212529'
  json.tooltip "Анкета #{event.employee_id_name} на собеседования"
  json.start event.interview_date
  json.end event.interview_date
  end

json.array!(@empl_cv_inbox) do |event|
  json.extract! event, :id, :interview_date
  json.id event.id
  json.url profile_employee_cvs_path(proposal_employee_id:  event.id)
  json.title event.employee_id_name
  json.color '#ffff00'
  json.textColor '#212529'
  json.tooltip "Анкета #{event.employee_id_name} дата приезда"
  json.start event.interview_date.strftime('%Y-%m-%d')
  json.end event.interview_date.strftime('%Y-%m-%d')
end

json.array!(@empl_cv_approved) do |event|
  json.extract! event, :id, :warranty_date
  json.id event.id
  json.url profile_employee_cvs_path(proposal_employee_id:  event.id)
  json.title event.employee_id_name
  json.color '#808080'
  json.textColor '#212529'
  json.tooltip "Анкета #{event.employee_id_name} ждет подтверждения оплаты заказчиком"
  json.start event.warranty_date
  json.end event.warranty_date + 1.days
end

json.array!(@empl_cv_reminders) do |event|
  json.extract! event, :id, :reminder
  json.id event.id
  json.url profile_employee_cvs_path(employee_cv_id:  event.id)
  json.title event.name
  json.color '#9046ff'
  json.textColor '#212529'
  json.tooltip "Напоминание для анкеты #{event.name}. Комментарии: #{event.comment}"
  json.start event.reminder
  json.end event.reminder
end