# frozen_string_literal: true

module Cmd
  module Order
    class Moderate
      include Interactor::Organizer

      organize Cmd::Order::ToModeration,
               Cmd::NotifyMail::Order::Moderate::NotifyAdmin,
               Cmd::NotifyMail::Order::Moderate::NotifyCustomer

      around do |interactor|
        ActiveRecord::Base.transaction do
          interactor.call
        end
      end
    end
  end
end
