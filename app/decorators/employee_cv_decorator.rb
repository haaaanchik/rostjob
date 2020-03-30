class EmployeeCvDecorator < ApplicationDecorator
  delegate_all

  def employee_cv_id
    model.id
  end

  def icon_chevron_or_minus(employee_cvs)
    deleted = employee_cvs.count
    h.content_tag(:i, class: "ml-2 mr-1 blue-text fas #{ deleted.zero? ? 'fa-minus' : 'fa-chevron-up'}") {}
  end

  def display_reminders
    return if object.reminder.nil?
    h.content_tag(:span, class: "data #{color_reminder}") { "#{reminder_date} #{reminder_time}" }
  end

  def reminder_date
    object.reminder&.strftime('%d.%m.%Y')
  end

  def reminder_time
    object.reminder&.strftime('%H:%M')
  end

  private

  def color_reminder
    case
    when object.reminder < Date.today
      ''
    when (object.reminder >= Date.today) && (object.reminder <= Date.today + 1.days)
      'yellow'
    else
      return
    end
  end
end
