module Cmd
  module NotifyMail
    module Ticket
      module Incident
        class Precedent
          include Interactor

          delegate :message,  to: :context
          delegate :incident, to: :context

          def call
            return unless message.text == 'Нет, кандидат был на собеседование, уточните пожалуйста'

            SendDirectMailJob.perform_now(attrs: { incident: incident }, method: 'informated_admin_about_precedent')
          end
        end
      end
    end
  end
end