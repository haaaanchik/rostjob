class ApplicationDecorator < Draper::Decorator
  # Define methods for all decorated objects.
  # Helpers are accessed through `helpers` (aka `h`). For example:
  #
  #   def percent_amount
  #     h.number_to_percentage object.amount, precision: 2
  #   end
  private

  def subject
    @subject ||= entity(model.subject_type, model.subject_id)
  end

  def obj
    @obj ||= entity(model.object_type, model.object_id)
  end

  def entity(type, id)
    type.camelize.constantize.find_by(id: id)
  end
end
