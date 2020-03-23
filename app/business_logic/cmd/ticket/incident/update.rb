module Cmd
  module Ticket
    module Incident
      class Update
        include Interactor

        def call
          context.fail! unless incident.update(incident_params)
          SendMailJob.perform_later(message: message,
                                    incident: incident,
                                    method: 'admin_dispute_notification') if send_message_admin
        end

        private

        def incident_params
          context.incident_params
        end

        def incident
          context.incident
        end

        def send_message_admin
          context.params[:send_message_admin]
        end

        def message
          context.params[:message]
        end
      end
    end
  end
end
