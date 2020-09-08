class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def created_at_str
    self.created_at.strftime('%d.%m.%Y')
  end
end
