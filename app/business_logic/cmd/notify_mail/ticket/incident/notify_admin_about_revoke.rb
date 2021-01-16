module Cmd
  module NotifyMail
    module Ticket
      module Incident
        class NotifyAdminAboutRevoke
          include Interactor

          delegate :incident, to: :context

          def call
            SendDirectMailJob.perform_now(attrs: { incident: incident, message: message},
                                          method: 'informated_admin_about_revoke')
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
