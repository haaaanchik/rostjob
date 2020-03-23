json.array!(@empl_cv_hired) do |event|
  json.extract! event, :id, :warranty_date
  json.id event.id
  json.title event.employee_id_name
  json.tooltip "Гарантийный период для анкеты #{event.employee_id_name}"
  json.color '#00ca5f'
  json.start event.hiring_date
  json.end event.warranty_date + 1.days
end

json.array!(@empl_cv_interview) do |event|
  json.extract! event, :id, :interview_date
  json.id event.id
  json.title event.employee_id_name
  json.color '#fd7e14'
  json.tooltip "Анкета #{event.employee_id_name} на собеседования"
  json.start event.interview_date
  json.end event.interview_date
  end

json.array!(@empl_cv_inbox) do |event|
  json.extract! event, :id, :interview_date
  json.id event.id
  json.title event.employee_id_name
  json.color '#fd7e14'
  json.tooltip "Анкета #{event.employee_id_name} дата приезда"
  json.start event.interview_date
  json.end event.interview_date
end

json.array!(@empl_cv_approved) do |event|
  json.extract! event, :id, :warranty_date
  json.id event.id
  json.title event.employee_id_name
  json.color '#808080'
  json.tooltip "Анкета #{event.employee_id_name} подтверждение оплаты заказчиком"
  json.start event.warranty_date
  json.end event.warranty_date
end

json.array!(@empl_cv_reminders) do |event|
  json.extract! event, :id, :reminder
  json.id event.id
  json.title event.name
  json.color '#ff0000'
  json.tooltip "Напоминание для анкеты #{event.name}. Комментарии: #{event.comment}"
  json.start event.reminder
  json.end event.reminder
end