# frozen_string_literal: true

class ActiveSpecializationsSpecification
  class << self
    def to_scope
      Specialization
        .joins(:positions)
        .order('specializations.title')
        .includes(positions: :price_group)
        .distinct
    end
  end
end
