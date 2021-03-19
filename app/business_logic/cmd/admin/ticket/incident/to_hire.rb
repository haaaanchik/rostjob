# frozen_string_literal: true

module Cmd
  module Admin
    module Ticket
      module Incident
        class ToHire
          include Interactor

          delegate :order, to: :context

          def call
            return if order.number_free_places >= 1

            order.update(number_additional_employees: 1)
          end
        end
      end
    end
  end
end
