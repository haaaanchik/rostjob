# frozen_string_literal: true

module Cmd
  module Admin
    module Ticket
      module Incident
        class Hire
          include Interactor::Organizer

          organize Cmd::Admin::Ticket::Incident::ToHire,
                   Cmd::ProposalEmployee::Hire,
                   Cmd::Ticket::Incident::Close,
                   Cmd::Ticket::Message::ToCreate

          around do |interactor|
            ActiveRecord::Base.transaction do
              interactor.call
            end
          end
        end
      end
    end
  end
end
