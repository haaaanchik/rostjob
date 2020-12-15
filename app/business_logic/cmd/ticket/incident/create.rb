# frozen_string_literal: true

module Cmd
  module Ticket
    module Incident
      class Create
        include Interactor::Organizer

        organize Cmd::Ticket::Incident::ToCreate,
                 Cmd::ProposalEmployee::ToDisput,
                 Cmd::NotifyMail::Ticket::Incident::Create

        around do |interactor|
          ActiveRecord::Base.transaction do
            interactor.call
          end
        end
      end
    end
  end
end