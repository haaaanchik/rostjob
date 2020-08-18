module Cmd
  module Admin
    module Ticket
      class Close
        include Interactor::Organizer

        organize Cmd::Ticket::Close,
                 Cmd::NotifyMail::Ticket::CloseByAdmin

        around do |interactor|
          ActiveRecord::Base.transaction do
            interactor.call
          end
        end
      end
    end
  end
end