module Cmd
  module Ticket
    module Incident
      class ToUpdate
        include Interactor

        delegate :incident,        to: :context
        delegate :incident_params, to: :context

        def call
          context.fail! unless incident.update(incident_params)
          SendMailJob.perform_later(message: message,
                                    incident: incident,
                                    method: 'admin_dispute_notification') if send_message_admin
        end

        private

        def send_message_admin
          context.params[:send_message_admin] || false
        end

        def message
          context.message_params[:text]
        end
      end
    end
  end
end
