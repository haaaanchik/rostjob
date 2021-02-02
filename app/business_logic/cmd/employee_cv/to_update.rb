# frozen_string_literal: true

module Cmd
  module EmployeeCv
    class ToUpdate
      include Interactor

      delegate :params,      to: :context
      delegate :employee_cv, to: :context

      def call
        context.fail! unless employee_cv.update(params)
      end
    end
  end
end
