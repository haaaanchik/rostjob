# frozen_string_literal: true

module Cmd
  module NotifyMail
    module Ticket
      module Incident
        class Create
          include Interactor

          delegate :incident, to: :context

          def call
            SendNotifyMailJob.perform_now(objects: [incident], method: 'informated_contractor_has_disputed')
          end
        end
      end
    end
  end
end
