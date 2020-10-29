class UserActionLogDecorator < ApplicationDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def role
    model.subject_role
  end

  def date
    model.created_at.strftime('%d.%m.%Y')
  end

  def time
    model.created_at.strftime('%H:%M')
  end

  def user_name
    return user_action_log.subject&.full_name if subject_type == 'User'

    Staffer.find_by(id: subject_id)&.name
  end
end
