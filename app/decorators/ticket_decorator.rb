class TicketDecorator < ApplicationDecorator
  delegate_all

  def header
    'Это заголовок'
  end

  def subject_name
    model.user.full_name
  end

  def hire_action_enabled?(_subject)
    false
  end

  def revoke_action_enabled?(_subject)
    false
  end

  def to_inbox_action_enabled?(_subject)
    false
  end

  def close_action_enabled?(_subject)
    false
  end

  def user_full_name
    full_name = object.user_id == h.current_user.id ? proposal_employee_user_name :
                                                      subject_name
    h.content_tag(:td) { full_name }
  end

  private

  def proposal_employee_user_name
    return if object.proposal_employee.nil?
    object.proposal_employee.profile.user.full_name
  end
end
