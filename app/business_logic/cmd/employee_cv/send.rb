# frozen_string_literal: true

module Cmd
  module EmployeeCv
    class Send
      include Interactor::Organizer

      organize Cmd::EmployeeCv::Create,
               Cmd::EmployeeCv::ToReady,
               Cmd::ProposalEmployee::Create

      around do |interactor|
        ActiveRecord::Base.transaction do
          interactor.call
        end
      end
    end
  end
end
