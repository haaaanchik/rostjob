class UserActionLogDecorator < ApplicationDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def login
    subject.email
  end

  def role
    model.subject_role
  end

  def order
    obj.order_id
  end

  def employee_cv
    obj.employee_cv_id
  end

  def date
    model.created_at.strftime('%d-%m-%Y')
  end

  def time
    model.created_at.strftime('%H:%M:%S')
  end

  private

  def subject
    @subject ||= entity(model.subject_type, model.subject_id)
  end

  def obj
    @obj ||= entity(model.object_type, model.object_id).decorate
  end

  def entity(type, id)
    type.camelize.constantize.find_by(id: id)
  end
end
