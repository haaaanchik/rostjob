class EmployeeCvDecorator < ApplicationDecorator
  delegate_all

  def employee_cv_id
    model.id
  end

  def icon_chevron_or_minus(employee_cvs)
    deleted = employee_cvs.count
    h.content_tag(:i, class: "ml-2 mr-1 blue-text fas #{ deleted.zero? ? 'fa-minus' : 'fa-chevron-up'}") {}
  end

  def display_reminders(reminder_status)
    return unless reminder_status

    h.content_tag(:p, class: "m-0 #{color_reminder}") { format_reminder }
  end

  def reminder_date
    object.reminder&.strftime('%d.%m.%Y')
  end

  def remove_reminder
    d_none = object.reminder.nil? ? 'display: none' : ''
    h.content_tag(:button, class: 'btn btn-sm btn-danger remove-reminder', style: d_none) { 'Удалить' }
  end

  private

  def color_reminder
    case
    when object.reminder < Date.today
      'red'
    when (object.reminder >= Date.today) && (object.reminder <= Date.today + 1.days)
      'yellow'
    else
      return
    end
  end

  def format_reminder
    l(object.reminder, format: '%d %B')
  end
end
