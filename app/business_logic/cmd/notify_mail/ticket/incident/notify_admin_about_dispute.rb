# frozen_string_literal: true

module Cmd
  module NotifyMail
    module Ticket
      module Incident
        class NotifyAdminAboutDispute
          include Interactor

          delegate :incident,           to: :context
          delegate :send_message_admin, to: :context

          def call
            SendMailJob.perform_now(message: message,
                                    attrs: { incident: incident },
                                    method: 'admin_dispute_notification') if send_message_admin
          end

          private

          def message
            context.message_params[:text]
          end
        end
      end
    end
  end
end
