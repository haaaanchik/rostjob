class UserActionLogDecorator < ApplicationDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def login
    subject.email
  end

  def role
    model.subject_role
  end

  def order
    obj.id if model.object_type.include? 'Order'
    obj.order.id if model.object_type.include? 'ProposalEmployee'
  end

  def employee_cv
    obj.id if model.object_type.include? 'EmployeeCv'
    obj.employee_cv.id if model.object_type.include? 'ProposalEmployee'
  end

  def date
    model.created_at.strftime('%d-%m-%Y')
  end

  def time
    model.created_at.strftime('%H:%M:%S')
  end
end
