# frozen_string_literal: true

module Cmd
  module Ticket
    module Incident
      class FailedInterview
        include Interactor::Organizer
        before :update_text

        organize Cmd::Ticket::ToUpdateWaiting,
                 Cmd::Ticket::Message::ToCreate,
                 Cmd::NotifyMail::Ticket::Incident::NotifyAdminAboutRevoke

        around do |interactor|
          ActiveRecord::Base.transaction do
            interactor.call
          end
        end

        private

        def update_text
          new_text = "Кандидату отказано в трудоустройстве или договор разорван на основании(ях): #{context.message_params[:text]}"

          context.message_params = { text: new_text }
        end
      end
    end
  end
end
