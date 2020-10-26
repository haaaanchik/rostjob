# frozen_string_literal: true

module Cmd
  module ProposalEmployee
    class Create
      include Interactor::Organizer

      organize Cmd::Order::AddToFavorites,
               Cmd::ProposalEmployee::ToCreate,
               Cmd::EmployeeCv::ToSent

      around do |interactor|
        ActiveRecord::Base.transaction do
          interactor.call
        end
      end
    end
  end
end
