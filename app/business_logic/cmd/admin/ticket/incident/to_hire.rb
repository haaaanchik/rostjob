# frozen_string_literal: true

module Cmd
  module Admin
    module Ticket
      module Incident
        class ToHire
          include Interactor

          delegate :order, to: :context

          def call
            order.update(number_additional_employees: 1) unless context.fail!
          end
        end
      end
    end
  end
end
