module Cmd
  module Ticket
    module Incident
      class Update
        include Interactor::Organizer

        organize Cmd::Ticket::Incident::ToUpdate,
                 Cmd::Ticket::Message::ToCreate,
                 Cmd::NotifyMail::Ticket::Incident::Precedent,
                 Cmd::NotifyMail::Ticket::Incident::NotifyAdminAboutDispute

        around do |interactor|
          ActiveRecord::Base.transaction do
            interactor.call
          end
        end
      end
    end
  end
end