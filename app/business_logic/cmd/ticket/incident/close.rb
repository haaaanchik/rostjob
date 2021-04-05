# frozen_string_literal: true

module Cmd
  module Ticket
    module Incident
      class Close
        include Interactor

        delegate :incident, to: :context

        def call
          return unless incident

          context.fail!(errors: 'Не удалось закрыть спор') unless incident.to_closed!
        end
      end
    end
  end
end
