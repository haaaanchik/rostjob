# frozen_string_literal: true

module Api
  module V1
    class SpecializationsController < ApiV1Controller
      def index
        specializations = ActiveSpecializationsSpecification.to_scope.map(&:title)

        render json: {
          objects: specializations
        }
      end
    end
  end
end
