# frozen_string_literal: true

class PublishedOrdersSpecification
  class << self
    def to_scope
      Order.published.includes(:city, :position, profile: :company, position: :specializations)
    end
  end
end
