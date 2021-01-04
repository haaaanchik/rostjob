# frozen_string_literal: true

module Cmd
  module Admin
    module Invoice
      class Pay
        include Interactor::Organizer

        organize Cmd::Invoice::ToPay,
                 Cmd::Profile::Balance::Up,
                 Cmd::Jobs::Order::Publication

        around do |interactor|
          ActiveRecord::Base.transaction do
            interactor.call
          end
        end
      end
    end
  end
end
