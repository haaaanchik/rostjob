# frozen_string_literal: true

module Cmd
  module Ticket
    module Incident
      class FailedInterview
        include Interactor::Organizer

        organize Cmd::ProposalEmployee::ToRevoke,
                 Cmd::Ticket::Message::Create,
                 Cmd::Ticket::Incident::Close,
                 Cmd::NotifyMail::Ticket::Incident::FailedInterview

        around do |interactor|
          ActiveRecord::Base.transaction do
            interactor.call
          end
        end
      end
    end
  end
end