class OrderDecorator < ObjDecorator
  delegate_all

  def order_id
    model.id
  end

  def urgency_title
    'Срочность заявки ' + I18n.t("enumerize.order.urgency.#{model.urgency}")
  end

  def urgency_low_class
    'text-info'
  end

  def urgency_middle_class
    model.urgency.middle? || model.urgency.high? ? 'text-warning' : 'invisible'
  end

  def urgency_high_class
    model.urgency.high? ? 'text-danger' : 'invisible'
  end

  def title_with_skill
    "№#{id} #{title}. #{skill}"
  end

  def icon_bookmark(active_id)
    h.content_tag(:i, class: "ml-2 mr-1 #{'fas fa-bookmark' if id == active_id}") {}
  end

  def icon_chevron_or_minus
    reversed = proposal_employees.reserved.count
    h.content_tag(:i, class: "ml-2 mr-1 blue-text fas #{ reversed.zero? ? 'fa-minus' : 'fa-chevron-up'}") {}
  end

  def proposal_employees_by_status(state)
    proposal_employees.includes(:employee_cv, profile: :user).send(state).order(:interview_date)
  end

  def without_paid_revoked_employees
    employee_cvs.where.not('proposal_employees.state': %w(paid revoked)).where(profile: h.current_profile )
  end
end
